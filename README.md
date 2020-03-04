# Policies

Open Policy Agent is a powerful library, and with tools like [Conftest](https://github.com/instrumenta/conftest),
[Gatekeeper](https://github.com/open-policy-agent/gatekeeper) and more it has many uses.

By focusing on shared policies we can lower the barrier to entry to using these tools, as well as make it easier to
learn the Rego language.


## An example

A good example of where this is useful is with Conftest, and its ability to pull policies from external sources.
Without being an expert in Rego, or needing to write any rules, it's possible to test your deployments with Conftest like so:

```console
$ conftest test --update github.com/instrumenta/policies.git//kubernetes deployment+service.yaml
FAIL - deployment+service.yaml - hello-kubernetes in the Deployment hello-kubernetes does not have a memory limit set
FAIL - deployment+service.yaml - hello-kubernetes in the Deployment hello-kubernetes does not have a CPU limit set
FAIL - deployment+service.yaml - hello-kubernetes in the Deployment hello-kubernetes doesn't drop all capabilities
FAIL - deployment+service.yaml - hello-kubernetes in the Deployment hello-kubernetes is not using a read only root filesystem
FAIL - deployment+service.yaml - hello-kubernetes in the Deployment hello-kubernetes allows priviledge escalation
FAIL - deployment+service.yaml - hello-kubernetes in the Deployment hello-kubernetes is running as root
--------------------------------------------------------------------------------
PASS: 1/7
WARN: 0/7
FAIL: 6/7
```

## Interested?

This repository is hopefully a staging ground to collect together some useful policies in one place. This is not a unique idea,
and the community is actively discussing sharing and reuse at the moment.

If you're interested in shared policies for Open Policy Agent please join the conversation. Join us on the Open Policy Agent
Slack in the `#registry` channel, as well as the `#falco-opa-registry` channel on the [CNCF Slack](https://slack.cncf.io/).
