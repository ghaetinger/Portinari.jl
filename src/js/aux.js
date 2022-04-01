export function splice_attributes(obj, attributes, span) {
  obj = splice_event_handles(obj, attributes['events'], span);
  obj = splice_animation(obj, attributes['duration']);
  obj = splice_attribute(obj, attributes['attr']);
  obj = splice_style(obj, attributes['style']);
  return obj;
}

function splice_attribute(obj, attribute) {
  const keys = Object.keys(attribute);
  return keys.reduce((_obj, attribute_key) => _obj.attr(attribute_key, attribute[attribute_key]), obj);
}

function splice_style(obj, style) {
  const keys = Object.keys(style);
  return keys.reduce((_obj, style_key) => _obj.style(style_key, style[style_key]), obj);
}

function splice_animation(obj, duration) {
  if (duration <= 0) { return obj };
  return obj.transition().duration(duration);
}

function splice_event_handles(obj, events, span) {
  if (span == null) { return obj; }

  return events.reduce((_obj, event) => _obj.on(event, function (e, d) {
    const count = span.value[event] == undefined ? 0 : span.value[event].count;
    span.value[event] = {'count': count + 1, 'data': d};
    span.dispatchEvent(new CustomEvent("input"));
  }), obj);
}
