import { KubernetesObject } from 'kpt-functions';
import * as pkgApiResource from './io.k8s.apimachinery.pkg.api.resource';
import * as apisMetaV1 from './io.k8s.apimachinery.pkg.apis.meta.v1';

// CrossVersionObjectReference contains enough information to let you identify the referred resource.
export class CrossVersionObjectReference {
  // API version of the referent
  public apiVersion?: string;

  // Kind of the referent; More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds"
  public kind: string;

  // Name of the referent; More info: http://kubernetes.io/docs/user-guide/identifiers#names
  public name: string;

  constructor(desc: CrossVersionObjectReference) {
    this.apiVersion = desc.apiVersion;
    this.kind = desc.kind;
    this.name = desc.name;
  }
}

// ExternalMetricSource indicates how to scale on a metric not associated with any Kubernetes object (for example length of queue in cloud messaging service, or QPS from loadbalancer running outside of cluster).
export class ExternalMetricSource {
  // metric identifies the target metric by name and selector
  public metric: MetricIdentifier;

  // target specifies the target value for the given metric
  public target: MetricTarget;

  constructor(desc: ExternalMetricSource) {
    this.metric = desc.metric;
    this.target = desc.target;
  }
}

// ExternalMetricStatus indicates the current value of a global metric not associated with any Kubernetes object.
export class ExternalMetricStatus {
  // current contains the current value for the given metric
  public current: MetricValueStatus;

  // metric identifies the target metric by name and selector
  public metric: MetricIdentifier;

  constructor(desc: ExternalMetricStatus) {
    this.current = desc.current;
    this.metric = desc.metric;
  }
}

// HorizontalPodAutoscaler is the configuration for a horizontal pod autoscaler, which automatically manages the replica count of any resource implementing the scale subresource based on the metrics specified.
export class HorizontalPodAutoscaler implements KubernetesObject {
  // APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#resources
  public apiVersion: string;

  // Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds
  public kind: string;

  // metadata is the standard object metadata. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata
  public metadata: apisMetaV1.ObjectMeta;

  // spec is the specification for the behaviour of the autoscaler. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#spec-and-status.
  public spec?: HorizontalPodAutoscalerSpec;

  // status is the current information about the autoscaler.
  public status?: HorizontalPodAutoscalerStatus;

  constructor(desc: HorizontalPodAutoscaler.Interface) {
    this.apiVersion = HorizontalPodAutoscaler.apiVersion;
    this.kind = HorizontalPodAutoscaler.kind;
    this.metadata = desc.metadata;
    this.spec = desc.spec;
    this.status = desc.status;
  }
}

export function isHorizontalPodAutoscaler(o: any): o is HorizontalPodAutoscaler {
  return o && o.apiVersion === HorizontalPodAutoscaler.apiVersion && o.kind === HorizontalPodAutoscaler.kind;
}

export namespace HorizontalPodAutoscaler {
  export const apiVersion = "autoscaling/v2beta2";
  export const group = "autoscaling";
  export const version = "v2beta2";
  export const kind = "HorizontalPodAutoscaler";

  // named constructs a HorizontalPodAutoscaler with metadata.name set to name.
  export function named(name: string): HorizontalPodAutoscaler {
    return new HorizontalPodAutoscaler({metadata: {name}});
  }
  // HorizontalPodAutoscaler is the configuration for a horizontal pod autoscaler, which automatically manages the replica count of any resource implementing the scale subresource based on the metrics specified.
  export interface Interface {
    // metadata is the standard object metadata. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata
    metadata: apisMetaV1.ObjectMeta;

    // spec is the specification for the behaviour of the autoscaler. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#spec-and-status.
    spec?: HorizontalPodAutoscalerSpec;

    // status is the current information about the autoscaler.
    status?: HorizontalPodAutoscalerStatus;
  }
}

// HorizontalPodAutoscalerCondition describes the state of a HorizontalPodAutoscaler at a certain point.
export class HorizontalPodAutoscalerCondition {
  // lastTransitionTime is the last time the condition transitioned from one status to another
  public lastTransitionTime?: apisMetaV1.Time;

  // message is a human-readable explanation containing details about the transition
  public message?: string;

  // reason is the reason for the condition's last transition.
  public reason?: string;

  // status is the status of the condition (True, False, Unknown)
  public status: string;

  // type describes the current condition
  public type: string;

  constructor(desc: HorizontalPodAutoscalerCondition) {
    this.lastTransitionTime = desc.lastTransitionTime;
    this.message = desc.message;
    this.reason = desc.reason;
    this.status = desc.status;
    this.type = desc.type;
  }
}

// HorizontalPodAutoscalerList is a list of horizontal pod autoscaler objects.
export class HorizontalPodAutoscalerList {
  // APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#resources
  public apiVersion: string;

  // items is the list of horizontal pod autoscaler objects.
  public items: HorizontalPodAutoscaler[];

  // Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds
  public kind: string;

  // metadata is the standard list metadata.
  public metadata?: apisMetaV1.ListMeta;

  constructor(desc: HorizontalPodAutoscalerList) {
    this.apiVersion = HorizontalPodAutoscalerList.apiVersion;
    this.items = desc.items.map((i) => new HorizontalPodAutoscaler(i));
    this.kind = HorizontalPodAutoscalerList.kind;
    this.metadata = desc.metadata;
  }
}

export function isHorizontalPodAutoscalerList(o: any): o is HorizontalPodAutoscalerList {
  return o && o.apiVersion === HorizontalPodAutoscalerList.apiVersion && o.kind === HorizontalPodAutoscalerList.kind;
}

export namespace HorizontalPodAutoscalerList {
  export const apiVersion = "autoscaling/v2beta2";
  export const group = "autoscaling";
  export const version = "v2beta2";
  export const kind = "HorizontalPodAutoscalerList";

  // HorizontalPodAutoscalerList is a list of horizontal pod autoscaler objects.
  export interface Interface {
    // items is the list of horizontal pod autoscaler objects.
    items: HorizontalPodAutoscaler[];

    // metadata is the standard list metadata.
    metadata?: apisMetaV1.ListMeta;
  }
}

// HorizontalPodAutoscalerSpec describes the desired functionality of the HorizontalPodAutoscaler.
export class HorizontalPodAutoscalerSpec {
  // maxReplicas is the upper limit for the number of replicas to which the autoscaler can scale up. It cannot be less that minReplicas.
  public maxReplicas: number;

  // metrics contains the specifications for which to use to calculate the desired replica count (the maximum replica count across all metrics will be used).  The desired replica count is calculated multiplying the ratio between the target value and the current value by the current number of pods.  Ergo, metrics used must decrease as the pod count is increased, and vice-versa.  See the individual metric source types for more information about how each type of metric must respond. If not set, the default metric will be set to 80% average CPU utilization.
  public metrics?: MetricSpec[];

  // minReplicas is the lower limit for the number of replicas to which the autoscaler can scale down. It defaults to 1 pod.
  public minReplicas?: number;

  // scaleTargetRef points to the target resource to scale, and is used to the pods for which metrics should be collected, as well as to actually change the replica count.
  public scaleTargetRef: CrossVersionObjectReference;

  constructor(desc: HorizontalPodAutoscalerSpec) {
    this.maxReplicas = desc.maxReplicas;
    this.metrics = desc.metrics;
    this.minReplicas = desc.minReplicas;
    this.scaleTargetRef = desc.scaleTargetRef;
  }
}

// HorizontalPodAutoscalerStatus describes the current status of a horizontal pod autoscaler.
export class HorizontalPodAutoscalerStatus {
  // conditions is the set of conditions required for this autoscaler to scale its target, and indicates whether or not those conditions are met.
  public conditions: HorizontalPodAutoscalerCondition[];

  // currentMetrics is the last read state of the metrics used by this autoscaler.
  public currentMetrics?: MetricStatus[];

  // currentReplicas is current number of replicas of pods managed by this autoscaler, as last seen by the autoscaler.
  public currentReplicas: number;

  // desiredReplicas is the desired number of replicas of pods managed by this autoscaler, as last calculated by the autoscaler.
  public desiredReplicas: number;

  // lastScaleTime is the last time the HorizontalPodAutoscaler scaled the number of pods, used by the autoscaler to control how often the number of pods is changed.
  public lastScaleTime?: apisMetaV1.Time;

  // observedGeneration is the most recent generation observed by this autoscaler.
  public observedGeneration?: number;

  constructor(desc: HorizontalPodAutoscalerStatus) {
    this.conditions = desc.conditions;
    this.currentMetrics = desc.currentMetrics;
    this.currentReplicas = desc.currentReplicas;
    this.desiredReplicas = desc.desiredReplicas;
    this.lastScaleTime = desc.lastScaleTime;
    this.observedGeneration = desc.observedGeneration;
  }
}

// MetricIdentifier defines the name and optionally selector for a metric
export class MetricIdentifier {
  // name is the name of the given metric
  public name: string;

  // selector is the string-encoded form of a standard kubernetes label selector for the given metric When set, it is passed as an additional parameter to the metrics server for more specific metrics scoping. When unset, just the metricName will be used to gather metrics.
  public selector?: apisMetaV1.LabelSelector;

  constructor(desc: MetricIdentifier) {
    this.name = desc.name;
    this.selector = desc.selector;
  }
}

// MetricSpec specifies how to scale based on a single metric (only `type` and one other matching field should be set at once).
export class MetricSpec {
  // external refers to a global metric that is not associated with any Kubernetes object. It allows autoscaling based on information coming from components running outside of cluster (for example length of queue in cloud messaging service, or QPS from loadbalancer running outside of cluster).
  public external?: ExternalMetricSource;

  // object refers to a metric describing a single kubernetes object (for example, hits-per-second on an Ingress object).
  public object?: ObjectMetricSource;

  // pods refers to a metric describing each pod in the current scale target (for example, transactions-processed-per-second).  The values will be averaged together before being compared to the target value.
  public pods?: PodsMetricSource;

  // resource refers to a resource metric (such as those specified in requests and limits) known to Kubernetes describing each pod in the current scale target (e.g. CPU or memory). Such metrics are built in to Kubernetes, and have special scaling options on top of those available to normal per-pod metrics using the "pods" source.
  public resource?: ResourceMetricSource;

  // type is the type of metric source.  It should be one of "Object", "Pods" or "Resource", each mapping to a matching field in the object.
  public type: string;

  constructor(desc: MetricSpec) {
    this.external = desc.external;
    this.object = desc.object;
    this.pods = desc.pods;
    this.resource = desc.resource;
    this.type = desc.type;
  }
}

// MetricStatus describes the last-read state of a single metric.
export class MetricStatus {
  // external refers to a global metric that is not associated with any Kubernetes object. It allows autoscaling based on information coming from components running outside of cluster (for example length of queue in cloud messaging service, or QPS from loadbalancer running outside of cluster).
  public external?: ExternalMetricStatus;

  // object refers to a metric describing a single kubernetes object (for example, hits-per-second on an Ingress object).
  public object?: ObjectMetricStatus;

  // pods refers to a metric describing each pod in the current scale target (for example, transactions-processed-per-second).  The values will be averaged together before being compared to the target value.
  public pods?: PodsMetricStatus;

  // resource refers to a resource metric (such as those specified in requests and limits) known to Kubernetes describing each pod in the current scale target (e.g. CPU or memory). Such metrics are built in to Kubernetes, and have special scaling options on top of those available to normal per-pod metrics using the "pods" source.
  public resource?: ResourceMetricStatus;

  // type is the type of metric source.  It will be one of "Object", "Pods" or "Resource", each corresponds to a matching field in the object.
  public type: string;

  constructor(desc: MetricStatus) {
    this.external = desc.external;
    this.object = desc.object;
    this.pods = desc.pods;
    this.resource = desc.resource;
    this.type = desc.type;
  }
}

// MetricTarget defines the target value, average value, or average utilization of a specific metric
export class MetricTarget {
  // averageUtilization is the target value of the average of the resource metric across all relevant pods, represented as a percentage of the requested value of the resource for the pods. Currently only valid for Resource metric source type
  public averageUtilization?: number;

  // averageValue is the target value of the average of the metric across all relevant pods (as a quantity)
  public averageValue?: pkgApiResource.Quantity;

  // type represents whether the metric type is Utilization, Value, or AverageValue
  public type: string;

  // value is the target value of the metric (as a quantity).
  public value?: pkgApiResource.Quantity;

  constructor(desc: MetricTarget) {
    this.averageUtilization = desc.averageUtilization;
    this.averageValue = desc.averageValue;
    this.type = desc.type;
    this.value = desc.value;
  }
}

// MetricValueStatus holds the current value for a metric
export class MetricValueStatus {
  // currentAverageUtilization is the current value of the average of the resource metric across all relevant pods, represented as a percentage of the requested value of the resource for the pods.
  public averageUtilization?: number;

  // averageValue is the current value of the average of the metric across all relevant pods (as a quantity)
  public averageValue?: pkgApiResource.Quantity;

  // value is the current value of the metric (as a quantity).
  public value?: pkgApiResource.Quantity;
}

// ObjectMetricSource indicates how to scale on a metric describing a kubernetes object (for example, hits-per-second on an Ingress object).
export class ObjectMetricSource {
  public describedObject: CrossVersionObjectReference;

  // metric identifies the target metric by name and selector
  public metric: MetricIdentifier;

  // target specifies the target value for the given metric
  public target: MetricTarget;

  constructor(desc: ObjectMetricSource) {
    this.describedObject = desc.describedObject;
    this.metric = desc.metric;
    this.target = desc.target;
  }
}

// ObjectMetricStatus indicates the current value of a metric describing a kubernetes object (for example, hits-per-second on an Ingress object).
export class ObjectMetricStatus {
  // current contains the current value for the given metric
  public current: MetricValueStatus;

  public describedObject: CrossVersionObjectReference;

  // metric identifies the target metric by name and selector
  public metric: MetricIdentifier;

  constructor(desc: ObjectMetricStatus) {
    this.current = desc.current;
    this.describedObject = desc.describedObject;
    this.metric = desc.metric;
  }
}

// PodsMetricSource indicates how to scale on a metric describing each pod in the current scale target (for example, transactions-processed-per-second). The values will be averaged together before being compared to the target value.
export class PodsMetricSource {
  // metric identifies the target metric by name and selector
  public metric: MetricIdentifier;

  // target specifies the target value for the given metric
  public target: MetricTarget;

  constructor(desc: PodsMetricSource) {
    this.metric = desc.metric;
    this.target = desc.target;
  }
}

// PodsMetricStatus indicates the current value of a metric describing each pod in the current scale target (for example, transactions-processed-per-second).
export class PodsMetricStatus {
  // current contains the current value for the given metric
  public current: MetricValueStatus;

  // metric identifies the target metric by name and selector
  public metric: MetricIdentifier;

  constructor(desc: PodsMetricStatus) {
    this.current = desc.current;
    this.metric = desc.metric;
  }
}

// ResourceMetricSource indicates how to scale on a resource metric known to Kubernetes, as specified in requests and limits, describing each pod in the current scale target (e.g. CPU or memory).  The values will be averaged together before being compared to the target.  Such metrics are built in to Kubernetes, and have special scaling options on top of those available to normal per-pod metrics using the "pods" source.  Only one "target" type should be set.
export class ResourceMetricSource {
  // name is the name of the resource in question.
  public name: string;

  // target specifies the target value for the given metric
  public target: MetricTarget;

  constructor(desc: ResourceMetricSource) {
    this.name = desc.name;
    this.target = desc.target;
  }
}

// ResourceMetricStatus indicates the current value of a resource metric known to Kubernetes, as specified in requests and limits, describing each pod in the current scale target (e.g. CPU or memory).  Such metrics are built in to Kubernetes, and have special scaling options on top of those available to normal per-pod metrics using the "pods" source.
export class ResourceMetricStatus {
  // current contains the current value for the given metric
  public current: MetricValueStatus;

  // Name is the name of the resource in question.
  public name: string;

  constructor(desc: ResourceMetricStatus) {
    this.current = desc.current;
    this.name = desc.name;
  }
}