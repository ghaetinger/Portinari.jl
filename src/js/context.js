import { d3 } from './d3-import.js';
import { splice_attributes } from './aux.js';
import { x_axis, y_axis } from "./primitives/axis.js";

export function context(parent_component, x_scale, y_scale, attributes, children, id) {
  const class_name = `ctx-${id}`;

  attributes["duration"] = 0;

  let ctx;
  ctx = parent_component.selectAll(`.${class_name}`)
                        .data([1])
                        .join("g");
  ctx = splice_attributes(ctx, attributes, null);
  ctx = ctx.attr("class", class_name);

  // Variables available to child functions: ctx, x_scale, y_scale
  children.map((child) => child(ctx, x_scale, y_scale));
  return ctx;
}

export function context_standalone(parent_component, x_domain, x_range, y_domain, y_range, attributes, children, id) {
  const class_name = `ctx-${id}`;

  attributes["duration"] = 0;

  let ctx;
  ctx = parent_component.selectAll(`.${class_name}`)
                        .data([1])
                        .join("g");

  const x_scale = x_axis(ctx, x_domain, x_range, id, true),
        y_scale = y_axis(ctx, y_domain, y_range, id, true);

  ctx = splice_attributes(ctx, attributes, null);
  ctx = ctx.attr("class", class_name);

  // Variables available to child functions: ctx, x_scale, y_scale
  children.map((child) => child(ctx, x_scale, y_scale));
  return ctx;
}
