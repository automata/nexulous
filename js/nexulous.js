// Generated by CoffeeScript 1.7.1
(function() {
  var animate, camera, container, cube, device, effect, init, renderer, scene;

  device = new THREEx.DeviceOrientationState();

  scene = null;

  camera = null;

  cube = null;

  effect = null;

  animate = function() {
    requestAnimationFrame(animate);
    camera.rotation.x = device.angleX();
    camera.rotation.y = device.angleY();
    camera.rotation.z = device.angleZ();
    return effect.render(scene, camera);
  };

  init = function() {
    var ambientLight;
    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 2000);
    camera.position.z = 2;
    cube = new THREE.Mesh(new THREE.CubeGeometry(1, 1, 1), new THREE.MeshBasicMaterial({
      color: 0xffffff,
      wireframe: true
    }));
    scene = new THREE.Scene();
    scene.add(cube);
    ambientLight = new THREE.AmbientLight(0xcccccc);
    scene.add(ambientLight);
    effect = new THREE.OculusRiftEffect(renderer, {
      worldScale: 10
    });
    return effect.setSize(window.innerWidth, window.innerHeight);
  };

  container = document.createElement('div');

  document.body.appendChild(container);

  renderer = new THREE.WebGLRenderer();

  renderer.setSize(window.innerWidth, window.innerHeight);

  container.appendChild(renderer.domElement);

  init();

  animate();

}).call(this);
