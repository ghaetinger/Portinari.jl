import { d3 } from '../d3-import.js';
import { splice_attributes } from '../aux.js';
import { x_axis, y_axis } from "./axis.js";

export function area(data, parent_component, x_scale, y_scale, attributes, span_id, curve) {
  const span = document.getElementById(span_id);
  if (span != null) {
    span.value = span.value || {};
  }

  const path = d3.area()
                 .x(d => x_scale(d.x))
                 .y0(d => y_scale(d.y0))
                 .y1(d => y_scale(d.y1))
                 .curve(curve)

  const class_name = `area-${span_id}`

  let area;
  area = parent_component.selectAll(`.${class_name}`)
                         .data([data])
                         .join("path");
  area = splice_attributes(area, attributes, span);
  area = area.attr("d", path)
             .attr("class", class_name)

  return area;
}

export function area_standalone(data, parent_component, attributes, span_id, curve, width=600, height=300) {
  const xs = data.map((v) => v.x),
        ys = data.map((v) => [v.y0, v.y1]).flat(),
        x_scale = x_axis(parent_component, [Math.min(...xs), Math.max(...xs)], [0.1 * width, 0.9 * width], span_id, true),
        y_scale = y_axis(parent_component, [Math.min(...ys), Math.max(...ys)], [0.1 * height, 0.9 * height], span_id, true);

  area(data, parent_component, x_scale, y_scale, attributes, span_id, curve);
}
