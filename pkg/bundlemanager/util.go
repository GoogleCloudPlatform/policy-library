package bundlemanager

import (
	"sort"
	"strings"
)

var bundlePrefix = "bundles.validator.forsetisecurity.org/"

// BundleAnnotation
func BundleAnnotation(key string) bool {
	return strings.HasPrefix(key, bundlePrefix)
}

func bundleControls(obj Object) map[string]string {
	tags := map[string]string{}
	for k, v := range obj.GetAnnotations() {
		if strings.HasPrefix(k, bundlePrefix) {
			tags[k] = v
		}
	}
	return tags
}

func allBundles(objs []Object) []string {
	var tags []string
	for _, obj := range objs {
		for k := range bundleControls(obj) {
			tags = append(tags, k)
		}
	}
	return uniqueSorted(tags)
}

func uniqueSorted(m []string) []string {
	keySet := map[string]struct{}{}
	for _, k := range m {
		keySet[k] = struct{}{}
	}
	return sortedSlice(keySet)
}

func sortedSlice(keySet map[string]struct{}) []string {
	var keys []string
	for k := range keySet {
		keys = append(keys, k)
	}
	return sorted(keys)
}

func sorted(strs []string) []string {
	sort.Strings(strs)
	return strs
}

func filter(objs []Object, predicate func(Object) bool) []Object {
	var filtered []Object
	for _, obj := range objs {
		if predicate(obj) {
			filtered = append(filtered, obj)
		}
	}
	return filtered
}

func inBundle(bundle string) func(Object) bool {
	return func(ct Object) bool {
		_, ok := ct.GetAnnotations()[bundle]
		return ok
	}
}

func notBundled() func(Object) bool {
	return func(ct Object) bool {
		return len(bundleControls(ct)) == 0
	}
}

func getControls(cts []Object, bundle string) []string {
	return ctsToStrs(cts, func(ct Object) string {
		return ct.GetAnnotations()[bundle]
	})
}

func getNames(cts []Object) []string {
	return ctsToStrs(cts, func(ct Object) string {
		return ct.GetName()
	})
}

func ctsToStrs(
	cts []Object,
	fn func(Object) string) []string {
	var strs []string
	for _, ct := range cts {
		strs = append(strs, fn(ct))
	}
	return sorted(strs)
}

func hasName(name string) func(Object) bool {
	return func(ct Object) bool {
		return ct.GetName() == name
	}
}
