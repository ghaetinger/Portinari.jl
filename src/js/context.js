import { d3 } from './d3-import.js';
import { static_splice_attributes } from './aux.js';
import { x_axis, y_axis } from "./primitives/axis.js";

export function context(parent_component, x_scale, x_domain, x_range, y_scale, y_domain, y_range, attributes, children, id) {
  const class_name = `ctx-${id}`;

  const width = (x_scale.range()[1] - x_scale.range()[0]);
  const height = (y_scale.range()[1] - y_scale.range()[0]);

  const new_x_range = [0, (x_range[1] - x_range[0]) * width];
  const new_y_range = [0, (y_range[1] - y_range[0]) * height];

  const center_origin = [new_x_range[1] / 2, new_y_range[1] /2];

  attributes["attr"]["transform"] =
    `translate(${x_scale.range()[0] + x_range[0] * width}, ${y_scale.range()[0] + y_range[0] * height})`;
  attributes["attr"]["transform-origin"] = `${center_origin[0]}px ${center_origin[1]}px`;

  let ctx;
  ctx = parent_component.selectAll(`.${class_name}`)
                        .data([1])
                        .join("g");
  ctx = static_splice_attributes(ctx, attributes, null);
  ctx = ctx.attr("class", class_name);

  const new_x_scale = x_axis(ctx, x_domain, new_x_range, id, false);
  const new_y_scale = y_axis(ctx, y_domain, new_y_range, id, false);

  // Variables available to child functions: ctx, x_scale, y_scale
  children.map((child) => child(ctx, new_x_scale, new_y_scale));
  return ctx;
}

export function context_standalone(parent_component, x_domain, x_range, y_domain, y_range, attributes, children, id) {
  const class_name = `ctx-${id}`;

  attributes["attr"]["transform-origin"] = "center";

  let ctx;
  ctx = parent_component.selectAll(`.${class_name}`)
                        .data([1])
                        .join("g");

  const x_scale = x_axis(ctx, x_domain, x_range, id, true),
        y_scale = y_axis(ctx, y_domain, y_range, id, true);

  ctx = static_splice_attributes(ctx, attributes, null);
  ctx = ctx.attr("class", class_name);

  // Variables available to child functions: ctx, x_scale, y_scale
  children.map((child) => child(ctx, x_scale, y_scale));
  return ctx;
}
