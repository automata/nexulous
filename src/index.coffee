cube = null
scene = null
camera = null
effect = null
renderer = null
controls = null
element = null
container = null
clock = new THREE.Clock()

init = ->
  renderer = new THREE.WebGLRenderer()
  element = renderer.domElement
  container = document.getElementById('target')
  container.appendChild(element)
  effect = new THREE.StereoEffect(renderer)
  renderer.setClearColor( 0xffffff );
  
  #
  # Build scene
  #

  scene = new THREE.Scene()
  scene.fog = new THREE.FogExp2( 0xffffff, 0.0025 );
  light = new THREE.DirectionalLight(0xffffff, 1.5)
  light.position.set(1, 1, 1)
  scene.add(light)

  light = new THREE.DirectionalLight(0xffffff, 0.75)
  light.position.set(-1, -0.5, -1)
  scene.add(light)

  ray = new THREE.Raycaster()
  ray.ray.direction.set(0, -1, 0)

  # Ground

  geometry = new THREE.PlaneGeometry(2000, 2000, 100, 100)
  geometry.applyMatrix(new THREE.Matrix4().makeRotationX(-Math.PI / 2))

  for vertex in geometry.vertices
    vertex.x += Math.random() * 20 - 10
    vertex.y += Math.random() * 2
    vertex.z += Math.random() * 20 - 10

  for face in geometry.faces
    face.vertexColors[0] = new THREE.Color().setHSL(Math.random() * 0.2 + 0.5, 0.75, Math.random() * 0.25 + 0.75)
    face.vertexColors[1] = new THREE.Color().setHSL(Math.random() * 0.2 + 0.5, 0.75, Math.random() * 0.25 + 0.75)
    face.vertexColors[2] = new THREE.Color().setHSL(Math.random() * 0.2 + 0.5, 0.75, Math.random() * 0.25 + 0.75)
  
  material = new THREE.MeshBasicMaterial({ vertexColors: THREE.VertexColors })
  mesh = new THREE.Mesh(geometry, material)
  scene.add(mesh)

  # Objects (sky)

  geometry = new THREE.BoxGeometry(20, 20, 20)

  for face in geometry.faces
    face.vertexColors[0] = new THREE.Color().setHSL(Math.random() * 0.2 + 0.5, 0.75, Math.random() * 0.25 + 0.75)
    face.vertexColors[1] = new THREE.Color().setHSL(Math.random() * 0.2 + 0.5, 0.75, Math.random() * 0.25 + 0.75)
    face.vertexColors[2] = new THREE.Color().setHSL(Math.random() * 0.2 + 0.5, 0.75, Math.random() * 0.25 + 0.75)

  for i in [0...200]
    material = new THREE.MeshPhongMaterial( { specular: 0xffffff, shading: THREE.FlatShading, vertexColors: THREE.VertexColors } )
    mesh = new THREE.Mesh( geometry, material )
    mesh.position.x = Math.floor( Math.random() * 20 - 10 ) * 80
    mesh.position.y = Math.floor( Math.random() * 20 ) * 20 + 120
    mesh.position.z = Math.floor( Math.random() * 20 - 10 ) * 80
    scene.add( mesh )

    material.color.setHSL( Math.random() * 0.2 + 0.5, 0.75, Math.random() * 0.25 + 0.75 )

  # Setup camera, device rotation and screen resize

  camera = new THREE.PerspectiveCamera(90, 1, 0.001, 700)
  camera.position.set(0, 10, 0)
  scene.add(camera)
  
  controls = new THREE.OrbitControls(camera, element)
  controls.rotateUp(Math.PI / 4)
  controls.target.set(
    camera.position.x + 0.1,
    camera.position.y,
    camera.position.z
  )
  controls.noZoom = true
  controls.noPan = true
  controls.autoRotate = true
  
  setOrientationControls = (e) ->
    return unless e.alpha
    controls = new THREE.DeviceOrientationControls(camera, true)
    controls.connect()
    controls.update()

    element.addEventListener('click', fullscreen, false)
    window.removeEventListener('deviceorientation', setOrientationControls)
    
  window.addEventListener('deviceorientation', setOrientationControls, true)

  window.addEventListener('resize', resize, false)
  setTimeout(resize, 1)
  window.addEventListener('resize', resize, false)

resize = ->
  width = container.offsetWidth
  height = container.offsetHeight

  camera.aspect = width / height
  camera.updateProjectionMatrix()

  renderer.setSize(width, height)
  effect.setSize(width, height)

update = (dt) ->
  resize()

  camera.updateProjectionMatrix()

  controls.update(dt)

render = (dt) ->
  effect.render(scene, camera)

animate = (t) ->
  requestAnimationFrame(animate)

  update(clock.getDelta())
  render(clock.getDelta())

fullscreen = ->
  if container.requestFullscreen
    container.requestFullscreen()
  else if container.msRequestFullscreen
    container.msRequestFullscreen()
  else if container.mozRequestFullScreen
    container.mozRequestFullScreen()
  else if container.webkitRequestFullscreen
    container.webkitRequestFullscreen()

init()
animate()
