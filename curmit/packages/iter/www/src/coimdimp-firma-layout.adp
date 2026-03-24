<html>
  <head>
<style type="text/css">
    * {
        box-sizing: border-box;
    }

    body, main {
        overscroll-behavior: contain;
        font-family: Arial, sans-serif;
    }

    main {
        width: 100%;/*800px;*/
	heigth: 100%;
        border: 1px solid #ddd;
        border-radius: 10px;
        margin: 20px auto;
        padding: 20px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        display: flex;
        flex-direction: column;
        align-items: center;
        touch-action: none;
    }

    .right-block {
        width: 100%;
    }

    .colors {
/*        background-color: #f5f5f5;
        text-align: center;
        padding: 10px 0;
        border-radius: 8px; */
    }

    .colors button {
        display: inline-block;
        border: 1px solid rgba(0, 0, 0, 0.15);
        border-radius: 50%;
        outline: none;
        cursor: pointer;
        width: 25px;
        height: 25px;
        margin: 8px;
        transition: transform 0.3s, box-shadow 0.3s;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    }

    .colors button:hover {
        transform: scale(1.2);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
    }

    .colors button:nth-of-type(1) {
        background-color: #0000ff;
    }

    .colors button:nth-of-type(2) {
        background-color: #009fff;
    }

    .colors button:nth-of-type(3) {
        background-color: #0fffff;
    }

    .colors button:nth-of-type(4) {
        background-color: #bfffff;
    }

    .colors button:nth-of-type(5) {
        background-color: #000000;
    }

    .brushes {
        padding-top: 10px;
        width: 100%;
    }

    .brushes button {
        display: block;
        width: 100%;
        border: none;
        background-color: #f5f5f5;
        margin-bottom: 8px;
        padding: 10px;
        height: 40px;
        outline: none;
        cursor: pointer;
        font-size: 14px;
        color: #333;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        transition: background-color 0.3s, box-shadow 0.3s;
        position: relative;
    }

    .brushes button:hover {
        background-color: #e0e0e0;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
    }

    .brushes button:after {
        content: '';
        display: block;
        background: #808080;
        position: absolute;
        left: 10px;
        right: 10px;
        bottom: 0;
    }

    .brushes button:nth-of-type(1):after {
        height: 1px;
    }

    .brushes button:nth-of-type(2):after {
        height: 2px;
    }

    .buttons {
        height: 50px;
        padding-top: 20px;
        display: flex;
        justify-content: center;
        gap: 10px;
    }

    .buttons button {
        display: inline-block;
        border: none;
        background-color: #f5f5f5;
        padding: 10px 20px;
        height: 40px;
        width: 180px;
        font-size: 16px;
        font-weight: bold;
        color: #333;
        border-radius: 8px;
        cursor: pointer;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        transition: background-color 0.3s, box-shadow 0.3s, transform 0.2s;
    }

    .buttons button:hover {
        background-color: #e0e0e0;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
        transform: translateY(-2px);
    }

    #paint-canvas {
        /* Placeholder for paint canvas styling */
    }
</style>
   
  </head>
  <body class="body">
      <div><p><big><b>@title@</b></big></p></div>
    <main>
      <formtemplate id="@form_name;noquote@">
	<formwidget   id="imgcode">
	  <formwidget   id="tipo_firma">
	  <formwidget id="submit_btn">
      </formtemplate>
      <div>
	<div class="right-block">
	  <canvas id="paint-canvas" width="800" height="350"></canvas>
      </div>
      <div align="center">
	<div class="colors">
	</div>
	<div class="brushes">
	</div>
	<div class="buttons">
	  <button id="clear" type="button">Pulisci</button>
	  <button id="save" type="button" >Conferma</button>
	</div>
      </div>
      </div>
    </main>

    <script>
      window.onload = function () {
      
      // Definitions
      var canvas = document.getElementById("paint-canvas");
      var context = canvas.getContext("2d");
      var boundings = canvas.getBoundingClientRect();
      
      // Specifications
      var mouseX = 0;
      var mouseY = 0;
      var touchX = 0;
      var touchY = 0;
      
      context.strokeStyle = 'black'; // initial brush color
      context.lineWidth = 1; // initial brush width
      var isDrawing = false;
      
      
      // Handle Colors
      var colors = document.getElementsByClassName('colors')[0];
      
      colors.addEventListener('click', function(event) {
      context.strokeStyle = event.target.value || 'black';
      });
      
      // Handle Brushes
      var brushes = document.getElementsByClassName('brushes')[0];
      
      brushes.addEventListener('click', function(event) {
      context.lineWidth = event.target.value || 1;
      });
      
      // Mouse Down Event
      canvas.addEventListener('mousedown', function(event) {
      setMouseCoordinates(event);
      isDrawing = true;
      
      // Start Drawing
      context.beginPath();
      context.moveTo(mouseX, mouseY);
      });
      
      // Mouse Move Event
      canvas.addEventListener('mousemove', function(event) {
      setMouseCoordinates(event);
      
      if(isDrawing){
      context.lineTo(mouseX, mouseY);
      context.stroke();
      }
      });
      
      // Mouse Up Event
      canvas.addEventListener('mouseup', function(event) {
      setMouseCoordinates(event);
      isDrawing = false;
      });
      
      // Handle Mouse Coordinates
      function setMouseCoordinates(event) {
      mouseX = event.clientX - boundings.left;
      mouseY = event.clientY - boundings.top;
      }


      //Gacalin
      // Touch Down Event
      canvas.addEventListener('touchstart', function(event) {
      setTouchCoordinates(event);
      isDrawing = true;
      
      // Start Drawing
      context.beginPath();
      context.moveTo(touchX, touchY);
      });

      // Touch Move Event
      canvas.addEventListener('touchmove', function(event) {
      setTouchCoordinates(event);
      
      if(isDrawing){
      context.lineTo(touchX, touchY);
      context.stroke();
      }
      });
      
      // Touch Up Event
      canvas.addEventListener('touchend', function(event) {
      setTouchCoordinates(event);
      isDrawing = false;
      });
      
      // Handle Touch Coordinates
      function setTouchCoordinates(event) {
      touchX = event.touches[0].clientX - boundings.left;
      touchY = event.touches[0].clientY - boundings.top;
      }
      
      // Handle Clear Button
      var clearButton = document.getElementById('clear');
      
      clearButton.addEventListener('click', function() {
      context.clearRect(0, 0, canvas.width, canvas.height);
      });
      
      // Handle Save Button
      var saveButton = document.getElementById('save');

      saveButton.addEventListener('click', function() {
      var imageName = 'TestFirma';
      var canvasDataURL = '';
      canvasDataURL = canvas.toDataURL();
      var a = document.createElement('a');
      a.href = canvasDataURL;
      var sim = document.getElementsByName('imgcode');
      document.getElementsByName('imgcode')[0].value = canvasDataURL;

      document.immagine_firma.submit();

//      var tipo_firma = document.getElementsByName('tipo_firma')[0].value;

//      if (tipo_firma == 'C') {
//          close();
//      }

//      a.download = imageName || 'drawing';
//      a.click();
      });
      };
      
    </script>
  </body>
</html>
