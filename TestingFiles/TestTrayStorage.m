%Test creating tray rack in random orientation and spawns in trays
clear
close
basetr = transl(1,0,0)*rpy2tr(0,0,0,'deg');
traystorage = TrayStorage(basetr);
trays = traystorage.addTrays(8);
camlight
axis equal
