import { d3 } from '../d3-import.js';
import { splice_attributes } from '../aux.js';

export function area(data, parent_component, x_scale, y_scale, attributes, span_id, curve) {
  const span = document.getElementById(span_id);
  if (span != null) {
    span.value = span.value || {};
    span.dispatchEvent(new CustomEvent("input"));
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
