package main

import (
	"flag"
	"fmt"
	"os"

	_ "github.com/golang/glog"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"

	"github.com/forseti-security/policy-library/cmd/policy-tool/status"
)

var (
	rootCmd = &cobra.Command{
		Use:   "policy-tool",
		Short: "tool for managing constraint template bundles",
	}
)

var glogFlags = map[string]struct{}{
	"alsologtostderr":  {},
	"log_backtrace_at": {},
	"log_dir":          {},
	"logtostderr":      {},
	"stderrthreshold":  {},
	"v":                {},
	"vmodule":          {},
}

func init() {
	rootCmd.AddCommand(status.Cmd)
	flag.CommandLine.VisitAll(func(f *flag.Flag) {
		if _, ok := glogFlags[f.Name]; ok {
			pflag.CommandLine.AddGoFlag(f)
		}
	})
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Printf("%#v\n", err)
		os.Exit(1)
	}
}
