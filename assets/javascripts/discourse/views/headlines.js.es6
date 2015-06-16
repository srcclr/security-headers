import AboutSite from 'discourse/views/static'

export default AboutSite.extend({
  templateName: 'headlines-charts',
  showCharts: function() {
    var mosaicCharts = ['mosaic_1', 'mosaic_2', 'mosaic_3'];
    var pieCharts = ['pie_1', 'pie_2', 'pie_3'];

    pieCharts.forEach(function(element) {
      let chart = new Chart(element, { percents: [60, 22, 18] });
      chart.drawPie();
    });

    mosaicCharts.forEach(function(element) {
      let chart = new Chart(element, { cells: generateDomainScores() });
      chart.drawMozaic();
    });

  }.on('didInsertElement')
});

function degreesToRadians(degrees) {
  return (degrees * Math.PI)/180;
}

function sumTo(a, i) {
  var sum = 0;
  for (let j = 0; j < i; j++) {
    sum += a[j];
  }
  return sum;
}

function generateDomainScores() {
  var scores = [];

  for(let i = 100; i > 0; i--) {
    scores.push(Math.floor((Math.random() * 3)));
  }

  return scores;
}

function Chart(id, o) {
  this.percents = o.percents;
  this.colors = ["#80cd85", "#f9c352", "#fd8365"];
  this.cells = o.cells;

  var data = [];

  if(this.percents) {
    for (let i = 0; i < this.percents.length; i++) {
      data.push(this.percents[i]*360/100);
    };
  }

  this.data = data;
  this.canvas = document.getElementById(id);
}

Chart.prototype = {
  select: function(segment) {
    var self = this;
    var context = this.canvas.getContext("2d");
    this.drawSegment(this.canvas, context, segment, this.data[segment], true);
  },

  drawMozaic: function() {
    var self = this;
    var context = this.canvas.getContext("2d");
    var cellSize = 10;
    var rowSize = 20;
    var margin = 1;
    var posX = 0;
    var posY = (cellSize + margin) * -1;

    for (let i = 0; i < this.cells.length; i++) {
      if(i % rowSize == 0) {
        posY =+ posY + cellSize + margin;
        posX = 0;
      }

      context.fillStyle = this.colors[this.cells[i]];
      context.fillRect(posX, posY, cellSize, cellSize);

      posX =+ posX + cellSize + margin;
    }
  },

  drawPie: function() {
    var self = this;
    var context = this.canvas.getContext("2d");

    for (let i = 0; i < this.data.length; i++) {
      this.drawSegment(this.canvas, context, i, this.data[i], false);
    }

    context.beginPath();
    context.arc(35, 35, 25, 0,2*Math.PI);
    context.fillStyle = "#fff";
    context.fill();
  },

  drawSegment: function(canvas, context, i, size, isSelected) {
    var self = this;
    context.save();
    var centerX = 35;
    var centerY = 35;
    var radius = 35;

    var degree = (self.data[i]/100)*360;

    var startingAngle = degreesToRadians(sumTo(self.data, i));
    var arcSize = degreesToRadians(size);
    var endingAngle = startingAngle + arcSize;

    context.beginPath();
    context.moveTo(centerX, centerY);
    context.arc(centerX, centerY, radius, startingAngle, endingAngle, false);
    context.closePath();

    context.fillStyle = self.colors[i];

    context.fill();
    context.restore();
  }
}
