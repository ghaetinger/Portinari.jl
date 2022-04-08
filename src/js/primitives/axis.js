import { d3 } from '../d3-import.js';

export function x_axis(parent_component, domain, range, id, show=false) {
  const x_scale = d3.scaleLinear()
                  .domain(domain)
                  .range(range);

  if (show) {
    const class_name = `x_axis-${id}`;
    axis(parent_component, x_scale, d3.axisBottom, class_name, show);
  }
  return x_scale;
}


export function y_axis(parent_component, domain, range, id, show=false) {
  const y_scale = d3.scaleLinear()
                  .domain(domain)
                  .range(range);

  if (show) {
    const class_name = `y_axis-${id}`;
    axis(parent_component, y_scale, d3.axisRight, class_name, show);
  }
  return y_scale;
}

function axis(parent_component, scale, axis_position, class_name) {
  const axis_descr = axis_position().scale(scale);
  const axis = parent_component.selectAll(`.${class_name}`)
                             .data([1])
                             .join("g")
                             .attr("class", class_name)
                             .call(axis_descr);
}
