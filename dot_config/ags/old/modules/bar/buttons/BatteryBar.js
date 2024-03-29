import icons from "../../../lib/icons.js"
import options from "../../../options.js"
import PanelButton from "../PanelButton.js"

const battery = await Service.import("battery")
let { bar, percentage, blocks, width, low } = options.bar.battery

percentage = Variable(percentage, {})

const Indicator = () => Widget.Icon({
  setup: self => self.hook(battery, () => {
    self.icon = battery.charging || battery.charged
      ? icons.battery.charging
      : battery.icon_name
  }),
})

const PercentLabel = () => Widget.Revealer({
  transition: "slide_right",
  click_through: true,
  reveal_child: percentage.bind(),
  child: Widget.Label({
    label: battery.bind("percent").as(p => `${p}%`),
  }),
})

const LevelBar = () => {
  const level = Widget.LevelBar({
    mode: 1,
    max_value: blocks,
    visible: bar !== "hidden",
    value: battery.bind("percent").as(p => (p / 100) * blocks),
  })
  const update = () => {
    level.value = (battery.percent / 100) * blocks
    level.css = `block { min-width: ${width / blocks}pt; }`
  }
  return level
  // .hook(width, update)
  // .hook(blocks, update)
  // .hook(bar, () => {
  //     level.vpack = bar.value === "whole" ? "fill" : "center"
  //     level.hpack = bar.value === "whole" ? "fill" : "center"
  // })
}

const WholeButton = () => Widget.Overlay({
  vexpand: true,
  child: LevelBar(),
  class_name: "whole",
  pass_through: true,
  overlay: Widget.Box({
    hpack: "center",
    children: [
      Widget.Icon({
        icon: icons.battery.charging,
        visible: Utils.merge([
          battery.bind("charging"),
          battery.bind("charged"),
        ], (ing, ed) => ing || ed),
      }),
      Widget.Box({
        hpack: "center",
        vpack: "center",
        child: PercentLabel(),
      }),
    ],
  }),
})

const Regular = () => Widget.Box({
  class_name: "regular",
  children: [
    Indicator(),
    PercentLabel(),
    LevelBar(),
  ],
})

export default () => PanelButton({
  class_name: "battery-bar",
  hexpand: false,
  on_clicked: () => { percentage.value = !percentage.value },
  child: Widget.Box({
    expand: true,
    visible: battery.bind("available"),
    child: bar === "whole" ? WholeButton() : Regular(),
  }),
  setup: self => {
    self.toggleClassName("bar-hidden", bar === "hidden")
    self.toggleClassName("charging", battery.charging || battery.charged)
    self.toggleClassName("low", battery.percent < low)
  }
})
