import { d3 } from '../d3-import.js';
import { splice_attributes } from '../attribute_splicing.js';
import { x_axis, y_axis } from "./axis.js";

export function bar(data, parent_component, x_scale, y_scale, attributes, span_id) {
    const span = document.getElementById(span_id);
    if (span != null) {
        span.value = span.value || {};
    }

    const class_name = `bar-${span_id}`;

    let width_foo, height_foo, x_foo, y_foo;

    if (data.length != 0 && typeof(data[0].x) == "string") {
        x_foo = d => x_scale(d.x);
        y_foo = d => y_scale(d.y);
        width_foo = x_scale.bandwidth;
        height_foo = d => (Math.max(...y_scale.range()) - y_scale(d.y));
    } else if (data.length != 0) {
        x_foo = _ => x_scale(0);
        y_foo = d => y_scale(d.y);
        width_foo = d => (x_scale(d.x));
        height_foo = y_scale.bandwidth;
    } else {
        x_foo = _ => 0;
        y_foo = _ => 0;
        width_foo = _ => 0;
        height_foo = _ => 0;
    }

    let bars = parent_component.selectAll(`.${class_name}`)
        .data(data)
        .join("rect");
    bars = splice_attributes(bars, attributes, span);
    bars = bars.attr("x", x_foo).attr("y", y_foo).attr("width", width_foo).attr("height", height_foo)
        .attr("class", class_name);

    return bars;
}

export function bar_standalone(data, parent_component, attributes, span_id, width = 600, height = 300) {
    const xs = data.map((v) => v.x),
        ys = data.map((v) => v.y);
    let x_scale, y_scale;
    if (data.length != 0 && typeof(data[0].x) == "string") {
        x_scale = x_axis(parent_component, [...xs], [0.1 * width, 0.9 * width], span_id, true);
        y_scale = y_axis(parent_component, [Math.min(...ys, 0), Math.max(...ys, 0)], [0.9 * height, 0.1 * height], span_id, true);
    } else {
        x_scale = x_axis(parent_component, [Math.min(...xs, 0), Math.max(...xs, 0)], [0.1 * width, 0.9 * width], span_id, true);
        y_scale = y_axis(parent_component, [...ys], [0.1 * height, 0.9 * height], span_id, true);
    }

    bar(data, parent_component, x_scale, y_scale, attributes, span_id);
}
