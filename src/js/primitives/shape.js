import { d3 } from '../d3-import.js';
import { splice_attributes } from '../attribute_splicing.js';
import { x_axis, y_axis } from "./axis.js";

export function shape(data, parent_component, x_scale, y_scale, attributes, span_id, shape_type) {
  const span = document.getElementById(span_id);
  if (span != null) {
    span.value = span.value || {};
  }

  const symbol = d3.symbol()
                   .type(shape_type)
                   .size(d => d.size);

  const class_name = `shape-${span_id}`

  let shape;
  shape = parent_component.selectAll(`.${class_name}`)
                          .data(data)
                          .join("path");
  shape = splice_attributes(shape, attributes, span);
  shape = shape.attr("transform", d => `translate(${x_scale(d.x)}, ${y_scale(d.y)})`)
               .attr("d", symbol)
               .attr("class", class_name)

  return shape;
}

export function shape_standalone(data, parent_component, attributes, span_id, shape_type, width=600, height=300) {
  const xs = data.map((v) => v.x),
        ys = data.map((v) => v.y),
        x_scale = x_axis(parent_component, [Math.min(...xs), Math.max(...xs)], [0.1 * width, 0.9 * width], span_id, true),
        y_scale = y_axis(parent_component, [Math.min(...ys), Math.max(...ys)], [0.1 * height, 0.9 * height], span_id, true);

  shape(data, parent_component, x_scale, y_scale, attributes, span_id, shape_type);
}
