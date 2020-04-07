"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
// CrossVersionObjectReference contains enough information to let you identify the referred resource.
class CrossVersionObjectReference {
    constructor(desc) {
        this.apiVersion = desc.apiVersion;
        this.kind = desc.kind;
        this.name = desc.name;
    }
}
exports.CrossVersionObjectReference = CrossVersionObjectReference;
// ExternalMetricSource indicates how to scale on a metric not associated with any Kubernetes object (for example length of queue in cloud messaging service, or QPS from loadbalancer running outside of cluster). Exactly one "target" type should be set.
class ExternalMetricSource {
    constructor(desc) {
        this.metricName = desc.metricName;
        this.metricSelector = desc.metricSelector;
        this.targetAverageValue = desc.targetAverageValue;
        this.targetValue = desc.targetValue;
    }
}
exports.ExternalMetricSource = ExternalMetricSource;
// ExternalMetricStatus indicates the current value of a global metric not associated with any Kubernetes object.
class ExternalMetricStatus {
    constructor(desc) {
        this.currentAverageValue = desc.currentAverageValue;
        this.currentValue = desc.currentValue;
        this.metricName = desc.metricName;
        this.metricSelector = desc.metricSelector;
    }
}
exports.ExternalMetricStatus = ExternalMetricStatus;
// HorizontalPodAutoscaler is the configuration for a horizontal pod autoscaler, which automatically manages the replica count of any resource implementing the scale subresource based on the metrics specified.
class HorizontalPodAutoscaler {
    constructor(desc) {
        this.apiVersion = HorizontalPodAutoscaler.apiVersion;
        this.kind = HorizontalPodAutoscaler.kind;
        this.metadata = desc.metadata;
        this.spec = desc.spec;
        this.status = desc.status;
    }
}
exports.HorizontalPodAutoscaler = HorizontalPodAutoscaler;
function isHorizontalPodAutoscaler(o) {
    return o && o.apiVersion === HorizontalPodAutoscaler.apiVersion && o.kind === HorizontalPodAutoscaler.kind;
}
exports.isHorizontalPodAutoscaler = isHorizontalPodAutoscaler;
(function (HorizontalPodAutoscaler) {
    HorizontalPodAutoscaler.apiVersion = "autoscaling/v2beta1";
    HorizontalPodAutoscaler.group = "autoscaling";
    HorizontalPodAutoscaler.version = "v2beta1";
    HorizontalPodAutoscaler.kind = "HorizontalPodAutoscaler";
    // named constructs a HorizontalPodAutoscaler with metadata.name set to name.
    function named(name) {
        return new HorizontalPodAutoscaler({ metadata: { name } });
    }
    HorizontalPodAutoscaler.named = named;
})(HorizontalPodAutoscaler = exports.HorizontalPodAutoscaler || (exports.HorizontalPodAutoscaler = {}));
// HorizontalPodAutoscalerCondition describes the state of a HorizontalPodAutoscaler at a certain point.
class HorizontalPodAutoscalerCondition {
    constructor(desc) {
        this.lastTransitionTime = desc.lastTransitionTime;
        this.message = desc.message;
        this.reason = desc.reason;
        this.status = desc.status;
        this.type = desc.type;
    }
}
exports.HorizontalPodAutoscalerCondition = HorizontalPodAutoscalerCondition;
// HorizontalPodAutoscaler is a list of horizontal pod autoscaler objects.
class HorizontalPodAutoscalerList {
    constructor(desc) {
        this.apiVersion = HorizontalPodAutoscalerList.apiVersion;
        this.items = desc.items.map((i) => new HorizontalPodAutoscaler(i));
        this.kind = HorizontalPodAutoscalerList.kind;
        this.metadata = desc.metadata;
    }
}
exports.HorizontalPodAutoscalerList = HorizontalPodAutoscalerList;
function isHorizontalPodAutoscalerList(o) {
    return o && o.apiVersion === HorizontalPodAutoscalerList.apiVersion && o.kind === HorizontalPodAutoscalerList.kind;
}
exports.isHorizontalPodAutoscalerList = isHorizontalPodAutoscalerList;
(function (HorizontalPodAutoscalerList) {
    HorizontalPodAutoscalerList.apiVersion = "autoscaling/v2beta1";
    HorizontalPodAutoscalerList.group = "autoscaling";
    HorizontalPodAutoscalerList.version = "v2beta1";
    HorizontalPodAutoscalerList.kind = "HorizontalPodAutoscalerList";
})(HorizontalPodAutoscalerList = exports.HorizontalPodAutoscalerList || (exports.HorizontalPodAutoscalerList = {}));
// HorizontalPodAutoscalerSpec describes the desired functionality of the HorizontalPodAutoscaler.
class HorizontalPodAutoscalerSpec {
    constructor(desc) {
        this.maxReplicas = desc.maxReplicas;
        this.metrics = desc.metrics;
        this.minReplicas = desc.minReplicas;
        this.scaleTargetRef = desc.scaleTargetRef;
    }
}
exports.HorizontalPodAutoscalerSpec = HorizontalPodAutoscalerSpec;
// HorizontalPodAutoscalerStatus describes the current status of a horizontal pod autoscaler.
class HorizontalPodAutoscalerStatus {
    constructor(desc) {
        this.conditions = desc.conditions;
        this.currentMetrics = desc.currentMetrics;
        this.currentReplicas = desc.currentReplicas;
        this.desiredReplicas = desc.desiredReplicas;
        this.lastScaleTime = desc.lastScaleTime;
        this.observedGeneration = desc.observedGeneration;
    }
}
exports.HorizontalPodAutoscalerStatus = HorizontalPodAutoscalerStatus;
// MetricSpec specifies how to scale based on a single metric (only `type` and one other matching field should be set at once).
class MetricSpec {
    constructor(desc) {
        this.external = desc.external;
        this.object = desc.object;
        this.pods = desc.pods;
        this.resource = desc.resource;
        this.type = desc.type;
    }
}
exports.MetricSpec = MetricSpec;
// MetricStatus describes the last-read state of a single metric.
class MetricStatus {
    constructor(desc) {
        this.external = desc.external;
        this.object = desc.object;
        this.pods = desc.pods;
        this.resource = desc.resource;
        this.type = desc.type;
    }
}
exports.MetricStatus = MetricStatus;
// ObjectMetricSource indicates how to scale on a metric describing a kubernetes object (for example, hits-per-second on an Ingress object).
class ObjectMetricSource {
    constructor(desc) {
        this.averageValue = desc.averageValue;
        this.metricName = desc.metricName;
        this.selector = desc.selector;
        this.target = desc.target;
        this.targetValue = desc.targetValue;
    }
}
exports.ObjectMetricSource = ObjectMetricSource;
// ObjectMetricStatus indicates the current value of a metric describing a kubernetes object (for example, hits-per-second on an Ingress object).
class ObjectMetricStatus {
    constructor(desc) {
        this.averageValue = desc.averageValue;
        this.currentValue = desc.currentValue;
        this.metricName = desc.metricName;
        this.selector = desc.selector;
        this.target = desc.target;
    }
}
exports.ObjectMetricStatus = ObjectMetricStatus;
// PodsMetricSource indicates how to scale on a metric describing each pod in the current scale target (for example, transactions-processed-per-second). The values will be averaged together before being compared to the target value.
class PodsMetricSource {
    constructor(desc) {
        this.metricName = desc.metricName;
        this.selector = desc.selector;
        this.targetAverageValue = desc.targetAverageValue;
    }
}
exports.PodsMetricSource = PodsMetricSource;
// PodsMetricStatus indicates the current value of a metric describing each pod in the current scale target (for example, transactions-processed-per-second).
class PodsMetricStatus {
    constructor(desc) {
        this.currentAverageValue = desc.currentAverageValue;
        this.metricName = desc.metricName;
        this.selector = desc.selector;
    }
}
exports.PodsMetricStatus = PodsMetricStatus;
// ResourceMetricSource indicates how to scale on a resource metric known to Kubernetes, as specified in requests and limits, describing each pod in the current scale target (e.g. CPU or memory).  The values will be averaged together before being compared to the target.  Such metrics are built in to Kubernetes, and have special scaling options on top of those available to normal per-pod metrics using the "pods" source.  Only one "target" type should be set.
class ResourceMetricSource {
    constructor(desc) {
        this.name = desc.name;
        this.targetAverageUtilization = desc.targetAverageUtilization;
        this.targetAverageValue = desc.targetAverageValue;
    }
}
exports.ResourceMetricSource = ResourceMetricSource;
// ResourceMetricStatus indicates the current value of a resource metric known to Kubernetes, as specified in requests and limits, describing each pod in the current scale target (e.g. CPU or memory).  Such metrics are built in to Kubernetes, and have special scaling options on top of those available to normal per-pod metrics using the "pods" source.
class ResourceMetricStatus {
    constructor(desc) {
        this.currentAverageUtilization = desc.currentAverageUtilization;
        this.currentAverageValue = desc.currentAverageValue;
        this.name = desc.name;
    }
}
exports.ResourceMetricStatus = ResourceMetricStatus;
//# sourceMappingURL=io.k8s.api.autoscaling.v2beta1.js.map