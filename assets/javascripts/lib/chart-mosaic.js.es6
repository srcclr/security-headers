function ChartMosaic(canvas, options) {
  this.colors = ["#80cd85", "#f9c352", "#fd8365"];
  this.options = options;
  this.context = canvas.getContext('2d');
  this.canvas = canvas;

  this.afterInitialize();
}

ChartMosaic.prototype.clear = function() {
  return this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
}

ChartMosaic.prototype.afterInitialize = function() {
  this.cells = this.options.cells;
  this.defaults = { cellSize: 10, rowSize: 20, margin: 1, posX: 0 };
}

ChartMosaic.prototype.draw = function() {
  this.clear();
  let {cellSize, rowSize, margin, posX } = this.defaults;
  let posY = (cellSize + margin) * -1;

  for (let i = 0; i < this.cells.length; i++) {
    if(i % rowSize == 0) {
      posY =+ posY + cellSize + margin;
      posX = 0;
    }

    this.context.fillStyle = this.colors[this.cells[i]];
    this.context.fillRect(posX, posY, cellSize, cellSize);

    posX =+ posX + cellSize + margin;
  }
}

export default ChartMosaic;
