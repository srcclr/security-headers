function degreesToRadians(degrees) {
  return (degrees * Math.PI) / 180;
}

function ChartPie(canvas, options) {
  this.colors = ["#FF5A2A", "#FFA123", "#FADD25", "#87CE1F"];
  this.options = options;
  this.context = canvas.getContext('2d');
  this.canvas = canvas;

  this.afterInitialize();
}

ChartPie.prototype.clear = function() {
  return this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
}

ChartPie.prototype.afterInitialize = function() {
  this.percents = this.options.percents || [];
}

ChartPie.prototype.increasAngle = function(radius) {
  this.angle += radius;

  if (this.angle >= 360) { this.angle = 0; }

}
ChartPie.prototype.draw = function() {
  this.clear();
  this.angle = 0;

  this.percents.forEach((score, index) => {
    this.drawSegment(score, this.colors[index]);
  })

  this.context.beginPath();
  this.context.arc(35, 35, 25, 0,2 * Math.PI);
  this.context.fillStyle = "#fff";
  this.context.fill();
}

ChartPie.prototype.drawSegment = function(score, color) {
  this.context.save();

  let angle = score * 360 / 100;
  let [centerX, centerY, radius] = [35, 35, 35];
  let degree = (angle / 100 ) * 360;

  let arcSize = degreesToRadians(angle);
  let startingAngle = degreesToRadians(this.angle);
  let endingAngle = startingAngle + arcSize;

  this.increasAngle(angle);

  this.context.beginPath();
  this.context.moveTo(centerX, centerY);
  this.context.arc(centerX, centerY, radius, startingAngle, endingAngle, false);
  this.context.closePath();
  this.context.fillStyle = color

  this.context.fill();
  this.context.restore();
}

export default ChartPie;
