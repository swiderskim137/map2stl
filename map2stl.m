clear;
P = 15; %greatest elevation to the rays
A=imread('Luna4k.tif');
%A=imread('Luna.jpg');
%reading matrix dimensions
w = size(A,1);
k = size(A,2);
%reading the topography into the h matrix
if size(A,3) > 1
    h = double(A(:,:,1));
else
    h = double(A);
end
m = max(max(h)) - min(min(h));
%clear A;
%smoothing
for krok = 1:1:1
    h(1,1)=(h(1,1)+h(2,1)+h(1,2)+h(2,2))/4;
    h(1,k)=(h(1,k)+h(2,k)+h(1,k-1)+h(2,k-1))/4;
    h(w,1)=(h(w,1)+h(w-1,1)+h(w,2)+h(w-1,2))/4;
    h(w,k)=(h(w,k)+h(w-1,k)+h(w,k-1)+h(w-1,k-1))/4;
    % for jj = 2:1:k-1
    %     sh=0;
    %     for xi = 1:1:2
    %         for yj = jj-1:1:jj+1
    %             sh=sh+h(xi,yj);
    %         end
    %     end
    %     h(1,jj)=sh/6;
    %     sh=0;
    %     for xi = w-1:1:w
    %         for yj = jj-1:1:jj+1
    %             sh=sh+h(xi,yj);
    %         end
    %     end
    %     h(w,jj)=sh/6;
    % end
    for ii = 2:1:w-1
        sh=0;
        for xi = ii-1:1:ii+1
            for yj = 1:1:2
                sh=sh+h(xi,yj);
            end
            sh=sh+h(xi,k);
        end
        h(ii,1)=sh/9;
        sh=0;
        for xi = ii-1:1:ii+1
            for yj = k-1:1:k
                sh=sh+h(xi,yj);
            end
            sh=sh+h(xi,1);
        end
        h(ii,1)=sh/9;
    end
    
    for ii = 2:1:w-1
        for jj = 2:1:k-1
            sh=0;
            for xi = ii-1:1:ii+1
                for yj = jj-1:1:jj+1
                    %if (abs(h(ii,jj)-h(xi,yj))>10) dh=dh+1; end;
                    sh=sh+h(xi,yj);
                end
            end
            %if (dh>6) h(ii,jj)=sh/9; end;
            h(ii,jj)=sh/9;
        end
    end
end
%increasing the matrix and copying the first column to the last place to obtain an even stitching of the shell
k = k + 1;
h(:,k) = h(:,1);
%calculation of the radius of the sphere
R = w/pi;
%changing the height of the topography based on the given parameter P
p = P/(R/m);
h = h./p;

[d,s] = meshgrid(0:1:k-1, 0:1:w-1);
ad = 360/(k-1);
as = 180/(w-1);

tem = pi/180;
for ii = 1:1:k
    for jj = 1:1:w
       %h(jj,ii) = sin(d(jj,ii))*sin(s(jj,ii))*0.1;
       kd = d(jj,ii)*ad;
       ks = -(s(jj,ii)*as - 90);
       x(jj,ii) = (R + h(jj,ii)) * cos(ks*tem) * cos(kd*tem);
       y(jj,ii) = (R + h(jj,ii)) * cos(ks*tem) * sin(kd*tem);
       z(jj,ii) = (R + h(jj,ii)) * sin(ks*tem);
       %[x(jj,ii),y(jj,ii),z(jj,ii)] = sph2cart(kd,ks,R);
    end
end
%f1 = figure;
%f2 = figure;
%figure(f1);
%surf(d,s,h);
%figure(f2);
surf(x,y,z);
axis equal;
xlabel('x'); 
ylabel('y'); 

(50/R)*(max(max(h)) - min(min(h)))


surf2stl('print.stl',x,y,z)
