/** Original procedural archive array. Composition: docs/rhine-redesign.md. */
import * as THREE from 'three';
import { RoomEnvironment } from 'three/addons/environments/RoomEnvironment.js';
import { RoundedBoxGeometry } from 'three/addons/geometries/RoundedBoxGeometry.js';

window.TUTORIALS_RHINE_SCENE = function createScene(host, books, onSelect) {
  const renderer = new THREE.WebGLRenderer({alpha:true,antialias:true,powerPreference:'low-power'});
  renderer.setPixelRatio(Math.min(devicePixelRatio || 1, 1.75));
  renderer.outputColorSpace=THREE.SRGBColorSpace;
  renderer.toneMapping=THREE.ACESFilmicToneMapping;
  renderer.toneMappingExposure=1.15;
  renderer.shadowMap.enabled=true;
  renderer.shadowMap.type=THREE.PCFSoftShadowMap;
  host.appendChild(renderer.domElement);
  const scene=new THREE.Scene();
  const camera=new THREE.PerspectiveCamera(32,1,.1,100);
  const pmrem=new THREE.PMREMGenerator(renderer);
  const room=new RoomEnvironment();
  const environment=pmrem.fromScene(room,.08);
  scene.environment=environment.texture;scene.environmentIntensity=.35;
  room.dispose();pmrem.dispose();
  const ambient=new THREE.HemisphereLight(0xfffaf0,0x79786b,2);
  scene.add(ambient);
  const light=new THREE.DirectionalLight(0xfff2da,3);
  light.position.set(-5,9,5);light.castShadow=true;
  light.shadow.mapSize.set(1024,1024);
  Object.assign(light.shadow.camera,{left:-12,right:12,top:12,bottom:-12,near:.1,far:40});
  light.shadow.bias=-.001;light.shadow.radius=5;
  scene.add(light);
  const fill=new THREE.DirectionalLight(0xffffff,1.3);fill.position.set(7,4,-4);scene.add(fill);
  const geometries=new Set(), materials=new Set(), textures=new Set();
  const geometry=g=>(geometries.add(g),g);
  const material=m=>(materials.add(m),m);
  const shell=material(new THREE.MeshPhysicalMaterial({color:0xe8e4db,roughness:.32,metalness:.04,transparent:true,opacity:.2,depthWrite:false,side:THREE.DoubleSide}));
  const edge=material(new THREE.MeshStandardMaterial({color:0xe5dfd1,roughness:.5,metalness:.12}));
  const paper=material(new THREE.MeshStandardMaterial({color:0xf1eee5,roughness:.9}));
  const metal=material(new THREE.MeshStandardMaterial({color:0xc8c2b1,roughness:.28,metalness:.72}));
  const gold=material(new THREE.MeshStandardMaterial({color:0xc2a16f,roughness:.35,metalness:.45}));
  const backGlass=geometry(new RoundedBoxGeometry(3.65,2.65,.14,2,.045));
  const pane=geometry(new THREE.PlaneGeometry(3.3,2.3));
  const rail=geometry(new THREE.BoxGeometry(3.68,.065,.26));
  const bolt=geometry(new THREE.CylinderGeometry(.035,.035,.025,8));
  const ring=geometry(new THREE.TorusGeometry(.65,.035,8,60));
  const smallRing=geometry(new THREE.TorusGeometry(.34,.045,8,40));
  const floor=new THREE.Mesh(geometry(new THREE.PlaneGeometry(45,45)),material(new THREE.ShadowMaterial({opacity:.07,color:0x514736})));
  floor.rotation.x=-Math.PI/2;floor.position.y=-.04;floor.receiveShadow=true;scene.add(floor);
  function labelTexture(book){
    const canvas=document.createElement('canvas');canvas.width=768;canvas.height=512;
    const c=canvas.getContext('2d');
    c.fillStyle='#f1eee6';c.fillRect(0,0,768,512);
    c.fillStyle='#b99b70';c.fillRect(32,28,12,12);
    c.fillStyle='#31342e';c.font='600 19px sans-serif';c.fillText('ATLAS / COURSE RECORD',58,42);
    c.font='12px monospace';c.fillText('RESEARCH LIBRARY',58,63);
    c.font='500 30px sans-serif';c.fillText('NO. '+book.no,32,112);
    c.strokeStyle='#c9c6ba';c.beginPath();c.moveTo(32,380);c.lineTo(736,380);c.stroke();
    c.fillStyle='#5d6057';c.font='12px monospace';c.fillText(book.en,32,408);
    c.fillStyle='#292d26';c.font='500 26px sans-serif';c.fillText(book.title,32,450);
    c.fillStyle='#777a70';c.font='11px monospace';c.fillText('STRUCTURE / THEORY / PRACTICE',32,480);
    const t=new THREE.CanvasTexture(canvas);t.colorSpace=THREE.SRGBColorSpace;textures.add(t);return t;
  }
  function dossier(book, detailed){
    const group=new THREE.Group();
    const rear=new THREE.Mesh(backGlass,paper);rear.position.z=-.075;rear.castShadow=true;group.add(rear);
    const front=new THREE.Mesh(backGlass,shell);front.position.z=.16;group.add(front);
    for(const y of [-1.29,1.29]){const m=new THREE.Mesh(rail,edge);m.position.set(0,y,.06);m.castShadow=true;group.add(m);}
    if(detailed){
      const sheet=new THREE.Mesh(pane,material(new THREE.MeshBasicMaterial({map:labelTexture(book),toneMapped:false})));sheet.position.z=.02;group.add(sheet);
      const big=new THREE.Mesh(ring,metal);big.position.set(-.35,.05,.27);group.add(big);
      const small=new THREE.Mesh(smallRing,gold);small.position.set(.75,.5,.27);group.add(small);
      for(const x of [-1.68,1.68])for(const y of [-1.15,1.15]){const screw=new THREE.Mesh(bolt,metal);screw.rotation.x=Math.PI/2;screw.position.set(x,y,.25);group.add(screw);}
    }
    return group;
  }
  const array=new THREE.Group();scene.add(array);
  const bookGroups=books.map((book,i)=>{
    const object=dossier(book,true);object.position.set(0,1.35,(i-(books.length-1)/2)*.64);array.add(object);return object;
  });
  // Quiet neighbouring lanes establish a library, without additional navigation.
  for(const x of [-4.05,4.05])for(let i=0;i<books.length+2;i++){
    const object=dossier(books[i%books.length],false);object.position.set(x,1.35,(i-(books.length+1)/2)*.64);array.add(object);
  }
  let selected=0,disposed=false,visible=true,raf=0,last=0;
  const reducedQuery=matchMedia('(prefers-reduced-motion: reduce)');
  let reduced=reducedQuery.matches;
  const raycaster=new THREE.Raycaster();
  const pointer=new THREE.Vector2();
  function bookAt(event){
    const rect=host.getBoundingClientRect();pointer.set((event.clientX-rect.left)/rect.width*2-1,-(event.clientY-rect.top)/rect.height*2+1);
    raycaster.setFromCamera(pointer,camera);
    const hits=raycaster.intersectObjects(bookGroups,true);
    if(!hits.length)return -1;
    let object=hits[0].object;while(object.parent!==array && object.parent)object=object.parent;
    return bookGroups.indexOf(object);
  }
  function onClick(event){const index=bookAt(event);if(index>=0)onSelect(index);}
  host.addEventListener('click',onClick);
  function render(now){
    raf=0;if(disposed || !visible || document.hidden)return;
    const dt=Math.min((now-(last || now))/1000,.05);last=now;
    let moving=false;
    bookGroups.forEach((book,i)=>{
      const target=i===selected?4.15:1.35;
      book.position.y=reduced?target:THREE.MathUtils.damp(book.position.y,target,5.5,dt);
      if(Math.abs(book.position.y-target)>.001)moving=true;
    });
    renderer.render(scene,camera);host.dataset.ready='true';
    if(moving&&!reduced)raf=requestAnimationFrame(render);
  }
  function wake(){if(!disposed&&!raf&&visible&&!document.hidden){last=0;raf=requestAnimationFrame(render);}}
  function resize(){
    const {width,height}=host.getBoundingClientRect();if(!width||!height)return;
    renderer.setSize(width,height,false);camera.aspect=width/height;
    const distance=camera.aspect<1.3?21:19;
    camera.position.set(distance*.58,distance*.48,distance*.72);camera.lookAt(0,2.1,0);camera.updateProjectionMatrix();wake();
  }
  function theme(){
    const dark=document.documentElement.dataset.theme==='dark';
    ambient.intensity=dark?.8:1;light.intensity=dark?1.2:1.7;
    shell.color.set(dark?0x999e91:0xe8e4db);edge.color.set(dark?0x929685:0xe5dfd1);
    paper.color.set(dark?0xb9bbae:0xf1eee5);renderer.toneMappingExposure=dark?.75:.85;wake();
  }
  const resizeObserver=new ResizeObserver(resize);resizeObserver.observe(host);
  const themeObserver=new MutationObserver(theme);themeObserver.observe(document.documentElement,{attributes:true,attributeFilter:['data-theme']});
  const visibilityObserver=new IntersectionObserver(entries=>{visible=entries[0].isIntersecting;if(visible)wake();else{cancelAnimationFrame(raf);raf=0;}},{rootMargin:'100px'});visibilityObserver.observe(host);
  function onVisibility(){if(!document.hidden)wake();else{cancelAnimationFrame(raf);raf=0;}}
  function onMotion(){reduced=reducedQuery.matches;wake();}
  document.addEventListener('visibilitychange',onVisibility);reducedQuery.addEventListener('change',onMotion);
  theme();resize();
  return {
    select(index){selected=THREE.MathUtils.clamp(index,0,books.length-1);wake();},
    dispose(){disposed=true;cancelAnimationFrame(raf);resizeObserver.disconnect();themeObserver.disconnect();visibilityObserver.disconnect();document.removeEventListener('visibilitychange',onVisibility);reducedQuery.removeEventListener('change',onMotion);host.removeEventListener('click',onClick);geometries.forEach(g=>g.dispose());materials.forEach(m=>m.dispose());textures.forEach(t=>t.dispose());environment.dispose();renderer.dispose();renderer.domElement.remove();delete host.dataset.ready;}
  };
};
