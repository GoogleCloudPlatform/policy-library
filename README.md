# Policies

This repo contains a library of constraint templates and sample constraints.

For information on setting up Config Validator to secure your environment, see the [User Guide](./docs/user_guide.md).

## Developing a Constraint

If this library doesn't contain a constraint that matches your use case, you can develop a new one
using the [Constraint Template Authoring Guide](./docs/constraint_template_authoring.md).

### Available Commands

```
make build                          Format and build
make build_templates                Inline Rego rules into constraint templates
make debug                          Show debugging output from OPA
make format                         Format Rego rules
make help                           Prints help for targets with comments
make test                           Test constraint templates via OPA
```

### Inlining
You can run `make build` to automatically inline Rego rules into your constraint templates.

This is done by finding a `INLINE("filename")` and `#ENDINLINE` statements in your yaml,
and replacing everything in between with the contents of the file.

For example, running `make build` would replace the raw content with the replaced content below

Raw:
```
#INLINE("my_rule.rego")
# This text will be replaced
#ENDINLINE
```

Replaced:
```
#INLINE("my_rule.rego")
#contents of my_rule.rego
#ENDINLINE
```
