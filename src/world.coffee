device = new THREEx.DeviceOrientationState()
scene = null
camera = null
cube = null
effect = null

animate = ->
  requestAnimationFrame(animate)

  camera.rotation.x = device.angleZ()
  camera.rotation.y = device.angleY()
  camera.rotation.z = device.angleX()
  
  effect.render(scene, camera)
  
init = ->
  camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 1000)
  camera.position.z = 2

  scene = new THREE.Scene()
  scene.fog = new THREE.Fog(0xffffff, 0, 750)

  light = new THREE.DirectionalLight(0xffffff, 1.5)
  light.position.set(1, 1, 1)
  scene.add(light)

  light = new THREE.DirectionalLight(0xffffff, 0.75)
  light.position.set(-1, -0.5, -1)
  scene.add(light)

  ray = new THREE.Raycaster()
  ray.ray.direction.set(0, -1, 0)

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
  
	# objects
  
  effect = new THREE.OculusRiftEffect(renderer, {worldScale: 100})
  effect.setSize( window.innerWidth, window.innerHeight )

	container = document.createElement('div')
	document.body.appendChild(container)

	renderer = new THREE.WebGLRenderer()
	renderer.setSize(window.innerWidth, window.innerHeight)
	container.appendChild(renderer.domElement)

init()
animate()
