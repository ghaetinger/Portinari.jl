import { d3 } from '../d3-import.js';
import { splice_attributes } from '../aux.js';

export function line(data, parent_component, x_scale, y_scale, attributes, span_id, curve) {
  const span = document.getElementById(span_id);
  if (span != null) {
    span.value = span.value || {};
    span.dispatchEvent(new CustomEvent("input"));
  }

  const path = d3.line()
                 .x(d => x_scale(d.x))
                 .y(d => y_scale(d.y))
                 .curve(curve)

  const class_name = `line-${span_id}`

  let line;
  line = parent_component.selectAll(`.${class_name}`)
                         .data([data])
                         .join("path");
  line = splice_attributes(line, attributes, span);
  line = line.attr("d", path)
             .attr("class", class_name)

  return line;
}
