import { d3 } from '../d3-import.js';
import { splice_attributes } from '../attribute_splicing.js';

export function axis(parent_component, direction, x_scale, y_scale, attributes, id) {
    const scale = direction in ['Left', 'Right'] ? y_scale : x_scale;
    const class_name = `axis-${id}`;
    const axis_position = d3[`axis${direction}`];
    draw_axis(parent_component, scale, axis_position, class_name, attributes);
}

export function x_axis(parent_component, domain, range, id, show=false, band_gap=0.2) {
  const scale = typeof(domain[0]) == "string" ? d3.scaleBand().padding(band_gap) : d3.scaleLinear();
  const x_scale = scale
                  .domain(domain)
                  .range(range);

  if (show) {
    const class_name = `x_axis-${id}`;
    draw_axis(parent_component, x_scale, d3.axisBottom, class_name);
  }
  return x_scale;
}


export function y_axis(parent_component, domain, range, id, show=false, band_gap=0.2) {
  const scale = typeof(domain[0]) == "string" ? d3.scaleBand().padding(band_gap) : d3.scaleLinear();
  const y_scale = scale
                  .domain(domain)
                  .range(range);

  if (show) {
    const class_name = `y_axis-${id}`;
    draw_axis(parent_component, y_scale, d3.axisRight, class_name);
  }
  return y_scale;
}

function draw_axis(parent_component, scale, axis_position, class_name, attributes=null) {
  const axis_descr = axis_position().scale(scale);
  let axis = parent_component.selectAll(`.${class_name}`)
      .data([1])
      .join("g")
      .attr("class", class_name);

  if (attributes != null) { axis = splice_attributes(axis, attributes, null); };
  axis.call(axis_descr);
}
