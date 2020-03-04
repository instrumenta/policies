package main

empty(value) {
  count(value) == 0
}

no_violations {
  empty(violation)
}

test_deployment_without_security_context {
  violation with input as {"kind": "Deployment", "metadata": {"name": "sample"}, "spec": {
    "template": { "spec": { "containers": [{"name": "same", "image": "image"}]}}}}
}

test_deployment_with_security_context {
  no_violations with input as {"kind": "Deployment", "metadata": {"name": "sample"}, "spec": {
    "selector": { "matchLabels": { "app": "something", "release": "something" }},
    "template": { "spec": { "securityContext": { "runAsNonRoot": true  }}}}}
}
