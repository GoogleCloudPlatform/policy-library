package status

import (
	"fmt"
	"os"

	"github.com/pkg/errors"
	"github.com/spf13/cobra"

	"github.com/forseti-security/policy-library/pkg/bundlemanager"
)

var Cmd = &cobra.Command{
	Use:     "status",
	Short:   "print status of the policy library's constraint templates and bundles",
	Example: ``,
	Run:     implWrapper(impl),
}

var (
	path string
)

func init() {
	Cmd.Flags().StringVar(&path, "path", "", "Path to the policies directory.")
}

func implWrapper(f func(cmd *cobra.Command, args []string) error) func(cmd *cobra.Command, args []string) {
	return func(cmd *cobra.Command, args []string) {
		if err := f(cmd, args); err != nil {
			fmt.Printf("%v\n", err)
			os.Exit(1)
		}
	}
}

func impl(cmd *cobra.Command, args []string) error {
	if path == "" {
		return errors.Errorf("sepcify --path")
	}

	bundleManager := bundlemanager.New()
	if err := bundleManager.Load(path); err != nil {
		return err
	}

	bundles := bundleManager.Bundles()
	for _, bundle := range bundles {
		controls := bundleManager.Controls(bundle)
		fmt.Printf("bundle: %s\n", bundle)
		for _, control := range controls {
			fmt.Printf(" control: %s\n", control)
		}
	}

	for _, obj := range bundleManager.All() {
		var unknown []string
		for k, v := range obj.GetAnnotations() {
			if !bundlemanager.BundleAnnotation(k) {
				unknown = append(unknown, fmt.Sprintf("%s=%s", k, v))
			}
		}
		if 0 != len(unknown) {
			fmt.Printf("resource %s has unknown annotations\n", obj.GetName())
			for _, v := range unknown {
				fmt.Printf("  %s\n", v)
			}
		}
	}

	unbundled := bundleManager.Unbundled()
	if len(unbundled) != 0 {
		fmt.Printf("unbundled constraint templates\n")
		for _, unbundled := range bundleManager.Unbundled() {
			fmt.Printf("  %s\n", unbundled)
		}
	}
	return nil
}
