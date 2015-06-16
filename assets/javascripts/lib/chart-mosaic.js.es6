import Chart from './chart'

class ChartMosaic extends Chart {
  afterInitialize() {
    this.cells = this.options.cells;
    this.defaults = { cellSize: 10, rowSize: 20, margin: 1, posX: 0 };
  }

  draw() {
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
}

export default ChartMosaic;
