package lib.kubernetes

default is_gatekeeper = false

is_gatekeeper {
	has_field(input, "review")
	has_field(input.review, "object")
}

object = input {
	not is_gatekeeper
}

object = input.review.object {
	is_gatekeeper
}

format(msg) = gatekeeper_format {
	is_gatekeeper
	gatekeeper_format = {"msg": msg}
}

format(msg) = msg {
	not is_gatekeeper
}

name = object.metadata.name

kind = object.kind

is_service {
	kind = "Service"
}

is_deployment {
	kind = "Deployment"
}

is_pod {
	kind = "Pod"
}

split_image(image) = [image, "latest"] {
	not contains(image, ":")
}

split_image(image) = [image_name, tag] {
	[image_name, tag] = split(image, ":")
}

pod_containers(pod) = all_containers {
	keys = {"containers", "initContainers"}
	all_containers = [c | keys[k]; c = pod.spec[k][_]]
}

containers[container] {
	pods[pod]
	all_containers = pod_containers(pod)
	container = all_containers[_]
}

containers[container] {
	all_containers = pod_containers(object)
	container = all_containers[_]
}

pods[pod] {
	is_deployment
	pod = object.spec.template
}

pods[pod] {
	is_pod
	pod = object
}

volumes[volume] {
	pods[pod]
	volume = pod.spec.volumes[_]
}

dropped_capability(container, cap) {
	container.securityContext.capabilities.drop[_] == cap
}

added_capability(container, cap) {
	container.securityContext.capabilities.add[_] == cap
}

has_field(obj, field) {
	obj[field]
}

no_read_only_filesystem(c) {
	not has_field(c, "securityContext")
}

no_read_only_filesystem(c) {
	has_field(c, "securityContext")
	not has_field(c.securityContext, "readOnlyRootFilesystem")
}

priviledge_escalation_allowed(c) {
	not has_field(c, "securityContext")
}

priviledge_escalation_allowed(c) {
	has_field(c, "securityContext")
	has_field(c.securityContext, "allowPrivilegeEscalation")
}

canonify_cpu(orig) = new {
  is_number(orig)
  new := orig * 1000
}

canonify_cpu(orig) = new {
  not is_number(orig)
  endswith(orig, "m")
  new := to_number(replace(orig, "m", ""))
}

# 10 ** 18
size_suffix("E") = 1000000000000000000 { true }

# 10 ** 15
size_suffix("P") = 1000000000000000 { true }

# 10 ** 12
size_suffix("T") = 1000000000000 { true }

# 10 ** 9
size_suffix("G") = 1000000000 { true }

# 10 ** 6
size_suffix("M") = 1000000 { true }

# 10 ** 3
size_suffix("K") = 1000 { true }

# 10 ** 0
size_suffix("") = 1 { true }

# 2 ** 10
size_suffix("Ki") = 1024 { true }

# 2 ** 20
size_suffix("Mi") = 1048576 { true }

# 2 ** 30
size_suffix("Gi") = 1073741824 { true }

# 2 ** 40
size_suffix("Ti") = 1099511627776 { true }

# 2 ** 50
size_suffix("Pi") = 1125899906842624 { true }

# 2 ** 60
size_suffix("Ei") = 1152921504606846976 { true }

get_suffix(mem) = suffix {
  not is_string(mem)
  suffix := ""
}

get_suffix(mem) = suffix {
  is_string(mem)
  count(mem) > 0
  suffix := substring(mem, count(mem) - 1, -1)
  size_suffix(suffix)
}

get_suffix(mem) = suffix {
  is_string(mem)
  count(mem) > 1
  suffix := substring(mem, count(mem) - 2, -1)
  size_suffix(suffix)
}

get_suffix(mem) = suffix {
  is_string(mem)
  count(mem) > 1
  not size_suffix(substring(mem, count(mem) - 1, -1))
  not size_suffix(substring(mem, count(mem) - 2, -1))
  suffix := ""
}

get_suffix(mem) = suffix {
  is_string(mem)
  count(mem) == 1
  not size_suffix(substring(mem, count(mem) - 1, -1))
  suffix := ""
}

get_suffix(mem) = suffix {
  is_string(mem)
  count(mem) == 0
  suffix := ""
}

canonify_storage(orig) = new {
  is_number(orig)
  new := orig
}

canonify_storage(orig) = new {
  not is_number(orig)
  suffix := get_suffix(orig)
  raw := replace(orig, suffix, "")
  re_match("^[0-9]+$", raw)
  new := to_number(raw) * size_suffix(suffix)
}
