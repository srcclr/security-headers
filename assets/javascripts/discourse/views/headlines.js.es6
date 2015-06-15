import AboutSite from 'discourse/views/static'

export default AboutSite.extend({
  templateName: 'headlines-charts',
  showCharts: function() {
    var site_1 = new Chart("site_1", {percents:[60, 22, 18]});
    var site_2 = new Chart("site_2", {percents:[60, 22, 18], cells:[1, 2, 0, 0, 0, 0, 0, 2, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1, 1, 1, 2, 0, 1, 0, 0, 0, 2, 1, 0, 1, 1, 2, 2, 0, 0, 2, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 2, 1, 0, 2, 1, 0, 0, 0, 1, 1, 2, 0, 0, 0, 2, 2, 0, 2, 1, 0, 0, 1, 2, 0, 1, 0, 0, 2, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0]});
    var site_3 = new Chart("site_3", {percents:[60, 22, 18]});

    site_1.drawPie();
    site_2.drawMozaic();
    site_3.drawPie();
  }.on('didInsertElement')
});


function Chart(id, o) {
  this.percents = o.percents ? o.percents : [60, 22, 18]; // in percents
  this.colors = o.colors ? o.colors : ["#80cd85", "#f9c352", "#fd8365"];
  this.cells = o.cells ? o.cells : [0, 1, 2, 0, 2, 1, 1, 2, 1, 0];

  var data = [];
  for (var i = 0; i < this.percents.length; i++) {
    data.push(this.percents[i]*360/100);
  };
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
    var x = 0;
    var y = (cellSize + margin) * -1;

    for (var i = 0; i < this.cells.length; i++) {
      if(i % rowSize == 0) {
        y =+ y + cellSize + margin;
        x = 0;
      }

      context.fillStyle = this.colors[this.cells[i]];
      context.fillRect(x, y, cellSize, cellSize);

      x =+ x + cellSize + margin;
    }
  },

  drawPie: function() {
    var self = this;
    var context = this.canvas.getContext("2d");

    for (var i = 0; i < this.data.length; i++) {
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

    var startingAngle = self.degreesToRadians(self.sumTo(self.data, i));
    var arcSize = self.degreesToRadians(size);
    var endingAngle = startingAngle + arcSize;

    context.beginPath();
    context.moveTo(centerX, centerY);
    context.arc(centerX, centerY, radius, startingAngle, endingAngle, false);
    context.closePath();

    context.fillStyle = self.colors[i];

    context.fill();
    context.restore();
  },


  // helper functions
  degreesToRadians: function(degrees) {
    return (degrees * Math.PI)/180;
  },

  sumTo: function(a, i) {
    var sum = 0;
    for (var j = 0; j < i; j++) {
      sum += a[j];
    }
    return sum;
  }
}

