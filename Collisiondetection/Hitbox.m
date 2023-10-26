classdef Hitbox < handle
    %An object that Stores parameter for a rectangular prism around an item in the item's parent frame
    %Used for collision checking.

    properties
        vertexes                    %stores corner of hitbox
        faces                       %breaks the face of the rectangle prism into triangles which share the same vertices. Stores the indexes of the corresponding vertices
        faceNormals                 %store normal vector of each face
    end
    
    methods
        function self = Hitbox(minCorner,maxCorner,itemBase)
            buffer = 0.02;                                                                  %Buffer zone so that item is fully enveloped by hitbox
            [vertex,face,faceNormal] = self.RectangularPrism(minCorner-buffer,maxCorner+buffer); %Create rectangular prism, uses RectangularPrism function from week 5 tutorial
            vertex = ([vertex,ones(size(vertex,1),1)])*itemBase.';                          %Converts vector arrays into homogenous form so it can be converted to item's parent frame
            faceNormal = ([faceNormal,ones(size(faceNormal,1),1)])*itemBase.';
            self.vertexes = vertex(:,1:3);                                                  %converting vector arrays back to non homogenous form and store them in object fields
            self.faceNormals = faceNormal(:,1:3);
            self.faces = face;
        end
        
        function update(self,minCorner,maxCorner,itemBase)
            %Used to update the position of the hitbox
            [vertex,face,faceNormal] = self.RectangularPrism(minCorner,maxCorner);           %Create rectangular prism, uses RectangularPrism function from week 5 tutorial
            vertex = ([vertex,ones(size(vertex,1),1)])*itemBase.';                      %Converts vector arrays into homogenous form so it can be converted to item's parent frame
            faceNormal = ([faceNormal,ones(size(faceNormal,1),1)])*itemBase.';
            self.vertexes = vertex(:,1:3);                                              %converting vector arrays back to non homogenous form and store them in object fields
            self.faceNormals = faceNormal(:,1:3);
            self.faces = face;
        end

        function plotBox(self)
            %Plots the hitbox in 3D space
            tcolor = [.2 .2 .8];
            patch('Faces',self.faces,'Vertices',self.vertexes,'FaceVertexCData',tcolor,'FaceColor','flat','lineStyle','none');

        end

        function [vertex,face,faceNormals] = RectangularPrism(self,lower,upper)
            %%RectangularPrism function taken from week 5 Lab. Creates a
            %%rectangular prism using the lower and upper corners of the
            %%prism. lower and upper are 1x3 position vectors.
            hold on
            vertex(1,:)=lower;
            vertex(2,:)=[upper(1),lower(2:3)];
            vertex(3,:)=[upper(1:2),lower(3)];
            vertex(4,:)=[upper(1),lower(2),upper(3)];
            vertex(5,:)=[lower(1),upper(2:3)];
            vertex(6,:)=[lower(1:2),upper(3)];
            vertex(7,:)=[lower(1),upper(2),lower(3)];
            vertex(8,:)=upper;
            
            face=[1,2,3;1,3,7;
                 1,6,5;1,7,5;
                 1,6,4;1,4,2;
                 6,4,8;6,5,8;
                 2,4,8;2,3,8;
                 3,7,5;3,8,5;
                 6,5,8;6,4,8];
            
            if 2 < nargout    
                faceNormals = zeros(size(face,1),3);
                for faceIndex = 1:size(face,1)
                    v1 = vertex(face(faceIndex,1)',:);
                    v2 = vertex(face(faceIndex,2)',:);
                    v3 = vertex(face(faceIndex,3)',:);
                    faceNormals(faceIndex,:) = unit(cross(v2-v1,v3-v1));
                end
            end
        end
    end
end

