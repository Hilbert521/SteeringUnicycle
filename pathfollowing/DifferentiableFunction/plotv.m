 function  plotv(x, varargin)
        %Unicycle.plotv Plot ground Unicycle pose
        %
        % If X (Nx3) is a matrix it is considered to represent a trajectory in which case
        % the Unicycle graphic is animated.
        %
        % Options::
        % 'scale',S    Draw Unicycle with length S x maximum axis dimension
        % 'fps',F      Frames per second in animation mode (default 10)
        %'x0'        initial position
        %'mode'   1:animation 2:plot
          opt.x0 = zeros(3,1);
         opt.scale = 1/40;
        opt.fps = 10;
        opt.mode=1;
      
        [opt,args] = tb_optparse(opt, varargin);

        dim=max(abs(opt.x0(1:2)))+0.5;
  
 %% animate the unicycle
 if opt.mode==1
     
        figure
        axis([-dim dim -dim dim]); 
        a = axis;
        d = (a(2)+a(4) - a(1)-a(3)) * opt.scale;
        axis('square');
        ax=gca;
        grid on
        
        robotposition = animatedline('color','k',...
        'linestyle','-',...
        'Parent',ax);
    
        h = hgtransform();
        hp = drawrobot([0 0 0],'k',2,d,d);
        for hh=hp
            set(hh, 'Parent', h);
        end
        %animate the path
            for i=1:numrows(x)
                T = transl([x(i,1:2) 0]) * trotz( x(i,3) );
                set(h, 'Matrix', T);
                 addpoints(robotposition,x(i,1),x(i,2));
                drawnow;
%                 pause(1/opt.fps);
            end
 else
 %% plot trajectory history           
          figure
          axis([-dim dim -dim dim]); 
          hold on;
          a = axis;
          d = (a(2)+a(4) - a(1)-a(3)) * opt.scale;
          axis('square');
          grid on;
        
          index=zeros(5,1);
          j=1;
         for i=1: floor(numrows(x)/5):numrows
             j=j+1;
             index(j,1)=i;
         end
              
           for  j=1:1:length(index)
               i=index(j,1);
            drawrobot([x(i,1),x(i,2),x(i,3)],'k',2,d,d);
           end
           hold on
           plot(x(:,1),x(:,2),'k-');
 end
         
    end

   