%Test creating tray rack in random orientation and spawns in trays
clear
close
basetr = transl(1,1.2,0)*rpy2tr(45,0,45,'deg');
traystorage = TrayStorage(basetr);
trays = traystorage.addTrays(16);
camlight
axis equal
