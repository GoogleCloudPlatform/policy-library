module github.com/forseti-security/policy-library

go 1.12

require (
	github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b
	github.com/open-policy-agent/frameworks v0.0.0-20190722192025-33c568209f31
	github.com/pkg/errors v0.8.0
	github.com/spf13/cobra v0.0.4
	k8s.io/apiextensions-apiserver v0.0.0-20190802061903-25691aabac0a // indirect
	k8s.io/apimachinery v0.0.0-20190802060556-6fa4771c83b3
	k8s.io/cli-runtime v0.0.0-20190731144734-e0b53a64da0b
	k8s.io/client-go v0.0.0-20190802021151-fdb3fbe99e1d
	k8s.io/kubectl v0.0.0-20190803022817-1937123dfffc
	sigs.k8s.io/controller-runtime v0.1.12 // indirect
)
