import { d3 } from '../d3-import.js';
import { splice_attributes } from '../aux.js';

export function shape(data, parent_component, x_scale, y_scale, attributes, span_id, shape_type) {
  const span = document.getElementById(span_id);
  if (span != null) {
    span.value = span.value || {};
    span.dispatchEvent(new CustomEvent("input"));
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
