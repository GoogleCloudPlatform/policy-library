package bundlemanager

import (
	"github.com/golang/glog"
	constraintv1alpha1 "github.com/open-policy-agent/frameworks/constraint/pkg/apis/templates/v1alpha1"
	"github.com/pkg/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"
	utilruntime "k8s.io/apimachinery/pkg/util/runtime"
	"k8s.io/cli-runtime/pkg/genericclioptions"
	"k8s.io/cli-runtime/pkg/resource"
	cmdutil "k8s.io/kubectl/pkg/cmd/util"
	"k8s.io/kubectl/pkg/scheme"
)

func init() {
	utilruntime.Must(constraintv1alpha1.AddToSchemes.AddToScheme(scheme.Scheme))
}

type Object interface {
	metav1.Object
	runtime.Object
}

var constraintTemplateGvk = schema.GroupVersionKind{
	Group:   "templates.gatekeeper.sh",
	Version: "v1alpha1",
	Kind:    "ConstraintTemplate",
}

type Bundle struct {
	CTs []Object
}

type CTInfo struct {
	obj Object
}

func (c *CTInfo) Controls() map[string]string {
	return bundleControls(c.obj)
}

type BundleManager struct {
	all []Object
}

func New() *BundleManager {
	return &BundleManager{}
}

func (b *BundleManager) Load(path string) error {
	filenameOptions := &resource.FilenameOptions{
		Recursive: true,
		Filenames: []string{path},
	}

	cfgFlags := genericclioptions.NewConfigFlags(true)
	f := cmdutil.NewFactory(cfgFlags)
	builder := f.NewBuilder()
	result := builder.
		Unstructured().
		Local().
		ContinueOnError().
		FilenameParam(false, filenameOptions).
		Flatten().
		Do()
	infos, err := result.Infos()
	if err != nil {
		return err
	}

	for _, info := range infos {
		glog.V(1).Infof("Found %s", info.Name)
		for k, v := range info.Object.(metav1.Object).GetAnnotations() {
			glog.V(2).Infof("  %s=%s", k, v)
		}
		if info.Object.GetObjectKind().GroupVersionKind() != constraintTemplateGvk {
			glog.V(2).Infof("skipping %s", info.Name)
			continue
		}
		b.add(info.Object.(Object))
	}
	return nil
}

func (b *BundleManager) add(obj Object) {
	b.all = append(b.all, obj)
}

func (b *BundleManager) All() []Object {
	return b.all
}

func (b *BundleManager) Bundles() []string {
	return allBundles(b.all)
}

func (b *BundleManager) Controls(bundle string) []string {
	return getControls(filter(b.all, inBundle(bundle)), bundle)
}

func (b *BundleManager) Unbundled() []string {
	return getNames(filter(b.all, notBundled()))
}

func (b *BundleManager) Bundle(name string) Bundle {
	return Bundle{CTs: filter(b.all, inBundle(name))}
}

func (b *BundleManager) Inspect(name string) (*CTInfo, error) {
	objs := filter(b.all, hasName(name))
	if len(objs) == 0 {
		return nil, errors.Errorf("ct %s not found", name)
	}
	obj := objs[0]
	return &CTInfo{obj: obj}, nil
}
