import { d3 } from '../d3-import.js';
import { splice_attributes } from '../aux.js';
import { x_axis, y_axis } from "./axis.js";

export function line(data, parent_component, x_scale, y_scale, attributes, span_id, curve) {
  const span = document.getElementById(span_id);
  if (span != null) {
    span.value = span.value || {};
  }

  const path = d3.line()
                 .x(d => x_scale(d.x))
                 .y(d => y_scale(d.y))
                 .curve(curve);

  const class_name = `line-${span_id}`;

  let line;
  line = parent_component.selectAll(`.${class_name}`)
                         .data([data])
                         .join("path");
  line = splice_attributes(line, attributes, span);
  line = line.attr("d", path)
             .attr("class", class_name);

  return line;
}

export function line_standalone(data, parent_component, attributes, span_id, curve, width=600, height=300) {
  const xs = data.map((v) => v.x),
        ys = data.map((v) => v.y),
        x_scale = x_axis(parent_component, [Math.min(...xs), Math.max(...xs)], [0.1 * width, 0.9 * width], span_id, true),
        y_scale = y_axis(parent_component, [Math.min(...ys), Math.max(...ys)], [0.1 * height, 0.9 * height], span_id, true);

  line(data, parent_component, x_scale, y_scale, attributes, span_id, curve);
}
