# Furniture Simulator
ARKit을 이용해 3D object를 방에 배치할 수 있는 프로젝트입니다. 

1. 서버에서 obj 파일을 받아온 후 File Manager를 이용해 로컬에 저장한다.
2. ARKit, SceneKit을 통해 obj 파일을 불러온 후 배치한다.
3. Gesture Recognizer를 통해서 선택한 object의 translate, rotate, scale을 조정한다.

* backend: fast api
* app: Swift, UIKit, RealityKit

![](capture.gif)
