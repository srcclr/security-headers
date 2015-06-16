class Chart {
  constructor(canvas, options) {
    this.colors = ["#80cd85", "#f9c352", "#fd8365"];
    this.options = options;
    this.context = canvas.getContext('2d');
    this.canvas = canvas;

    this.afterInitialize();
  }

  afterInitialize() { }

  clear() {
    this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
  }
}

export default Chart;
