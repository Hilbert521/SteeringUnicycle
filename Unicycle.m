%Steering control of unicycles
%
% This class steers a unicycle from initial position in SE(2) to origion aligned with the positive 'x' direction.  

% Methods::

%   control      generate the control inputs for the Unicycle
%   update       update the Unicycle state
%   run          run for multiple time steps
%   plot         plot/animate Unicycle on current figure
%   plot_xy      plot the path of the Unicycle
%
% Class methods::
%   plotv        plot/animate a pose on current figure
%
% Properties (read/write)::
%   x                 true Unicycle state: x, y, phi (3x1)
%   maxspeed        maximum Unicycle speed
%   dt              sample interval
%   x_hist          history of true Unicycle state (Nx3)

% Author: Junjie Fu Peking University
% Email: fujunjie89@gmail.com


% Examples::
%
% Create a Unicycle with initial position and control parameter
%       v = Unicycle(k,gamma,h,[-1 1 3*pi/4]');
% run
%      v.run(1000)
% which shows an animation of the Unicycle moving for 1000 time steps



classdef Unicycle < handle

    properties
        % state
        x           % state (x,y,phi)
        x_hist      % x history

        % parameters
        maxspeed    % maximum speed
        dim         % dimension of the world
        dt           % sample interval
        
       
        angles %phi,theta,alpha
        %controller parameters
        k
        gamma
        h
        
    end

    methods

        function veh = Unicycle(k,gamma,h,varargin)
        %Unicycle object constructor
        %
        % V = Unicycle(OPTIONS)  creates a Unicycle object
        %
        % Options::
        % 'vmax',S        Maximum speed (default [])
        % 'dt',T          Time interval
      
            
          
            
            opt.vmax = [];
            opt.dt = 0.001;
            opt.x0 = zeros(3,1);
            opt = tb_optparse(opt, varargin);
            
            veh.dt = opt.dt;
            veh.maxspeed = opt.vmax;
            veh.x=opt.x0(:);
   
    
            veh.k=k;
            veh.gamma=gamma;
            veh.h=h;
            
            veh.dim=max(abs(opt.x0(1:2)));

            veh.x_hist = [];
            veh.angles=[];
        end

      

        function  update(veh, u)
            %Unicycle.update Update the Unicycle state
           % with u=[speed,steer].
            %
            % Notes::
            % - Appends new state to state history property x_hist.
            
             theta=atan2(-veh.x(2),-veh.x(1));
             if mod(veh.x(3),2*pi)<pi
             alpha=theta-mod(veh.x(3),2*pi);
             else
                   alpha=theta-mod(veh.x(3),2*pi)+2*pi;
             end
              if mod(veh.x(3),2*pi)<pi
             veh.angles=[veh.angles;mod(veh.x(3),2*pi) theta alpha];
               else
                   veh.angles=[veh.angles;mod(veh.x(3),2*pi)-2*pi theta alpha];
              end
             
             u = veh.control();
             
            veh.x(1) = veh.x(1) + u(1)*veh.dt*cos(veh.x(3));
            veh.x(2) = veh.x(2) + u(1)*veh.dt*sin(veh.x(3));
            veh.x(3) = veh.x(3) + veh.dt * u(2);
           
            veh.x_hist = [veh.x_hist; veh.x'];   % maintain history
            
        end


        function u = control(veh)
            %Unicycle.control Compute the control input to Unicycle
            
            
             e=norm([veh.x(1),veh.x(2)],2);
             theta=atan2(-veh.x(2),-veh.x(1));
             if mod(veh.x(3),2*pi)<pi
             alpha=theta-mod(veh.x(3),2*pi);
             else
                   alpha=theta-mod(veh.x(3),2*pi)+2*pi;
             end
                    
             speed = veh.gamma*cos(alpha)*e;
%              if alpha~=0
%              steer=veh.k*alpha+veh.gamma*cos(alpha)*sin(alpha)/alpha*(alpha+veh.h*theta);
%              else
%                  steer=veh.gamma*veh.h*theta;
%              end
%             
            
             steer=veh.k*alpha+veh.gamma*cos(alpha)*sin(alpha)/alpha*(alpha+veh.h*theta);
            

            % clip the speed
            if ~isempty(veh.maxspeed)
            u(1) = min(veh.maxspeed, max(-veh.maxspeed, speed));
            else
                u(1)=speed;
            end
            u(2) = steer;
        end

        function p = run(veh, nsteps)
            %Unicycle.run Run the Unicycle simulation
            %
            % V.run(N) runs the Unicycle model for N timesteps and plots
            % the Unicycle pose at each step.
            %
            % P = V.run(N) runs the Unicycle simulation for N timesteps and
            % return the state history (Nx3) without plotting.  Each row
            % is (x,y,theta).
            %
            % See also Unicycle.step.

            if nargin < 2
                nsteps = 10000;
            end


            veh.visualize();
            fps=1;
            for i=1:nsteps
                veh.update();
                if nargout == 0
                    % if no output arguments then plot each step
                    veh.plot();
                    drawnow
                    hold on
                    veh.plot_xy();   
%                     pause(1/fps);
                end
            end
            p = veh.x_hist;
        end

        
        function h = plot(veh, varargin)
        %Unicycle.plot Plot Unicycle
        %
        %
        % Options::
        % 'scale',S    Draw Unicycle with length S x maximum axis dimension
        % 'color',C    Color of Unicycle.
        % 'fill'       Filled
        %
        % See also Unicycle.plotv.

            h = findobj(gcf, 'Tag', 'Unicycle.plot');
            if isempty(h)
                % no instance of Unicycle graphical object found
                h = Unicycle.plotv(veh.x, varargin{:});
                set(h, 'Tag', 'Unicycle.plot');  % tag it
            else
                Unicycle.plotv(h, veh.x);    % use current state
            end
        end

        function out = plot_xy(veh, varargin)
            %Unicycle.plot_xy Plots path followed by Unicycle
            %
            % V.plot_xy() plots the true xy-plane path followed by the Unicycle.
            %
            % V.plot_xy(LS) as above but the line style arguments LS are passed
            % to plot.
            %
            % Notes::
            % - The path is extracted from the x_hist property.
            
            xyt = veh.x_hist;
            if nargout == 0
                plot(xyt(:,1), xyt(:,2), varargin{:});
            else
                out = xyt;
            end
        end

        function visualize(veh)
            d=veh.dim+1;
            axis([-d d -d d]);
            grid on
        end
        
    end % method

    methods(Static)

        function h_ = plotv(x, varargin)
        %Unicycle.plotv Plot ground Unicycle pose
        %
        % H = Unicycle.plotv(X, OPTIONS) draws a representation of a ground robot as an 
        % oriented triangle with pose X (1x3) [x,y,theta].  H is a graphics handle.
        % If X (Nx3) is a matrix it is considered to represent a trajectory in which case
        % the Unicycle graphic is animated.
        %
        % Unicycle.plotv(H, X) as above but updates the pose of the graphic represented
        % by the handle H to pose X.
        %
        % Options::
        % 'scale',S    Draw Unicycle with length S x maximum axis dimension
        % 'color',C    Color of Unicycle.
        % 'fill'       Filled with solid color as per 'color' option
        % 'fps',F      Frames per second in animation mode (default 10)
        %
        % Notes::
        % - This is a class method.
        %
        % See also Unicycle.plot.
        
         if (numel(x) > 3) && (numcols(x) == 3)
                % animation mode set up the axis
                 veh.visualize();
         end

            if isscalar(x) && ishandle(x)
                % plotv(h, x)
                h = x;
                x = varargin{1};
                x = x(:)';
                T = transl([x(1:2) 0]) * trotz( x(3) );
                set(h, 'Matrix', T);
                return
            end

            opt.scale = 1/20;
            opt.fill = false;
            opt.color = 'r';
            opt.fps = 10;
            
            [opt,args] = tb_optparse(opt, varargin);

            lineprops = { 'Color', opt.color' };
            if opt.fill
                lineprops = [lineprops 'fill' opt.color ];
            end
            
            
                % get the current axes dimensions
                a = axis;
                d = (a(2)+a(4) - a(1)-a(3)) * opt.scale;
            
            % draw it
            points = [
                d 0
                -d -0.6*d
                -d 0.6*d
            ]';
            
            h = hgtransform();
            hp = plot_poly(points, lineprops{:});
            for hh=hp
                set(hh, 'Parent', h);
            end

            if (numel(x) > 3) && (numcols(x) == 3)
                % animation mode
                for i=1:numrows(x)
                    T = transl([x(i,1:2) 0]) * trotz( x(i,3) );
                    set(h, 'Matrix', T);
                    drawnow;
                    pause(1/opt.fps);
                end
            elseif (numel(x) == 3)
                % compute the pose
                % convert vector form of pose to SE(3)
                x = x(:)';
                T = transl([x(1:2) 0]) * trotz( x(3) );
                set(h, 'Matrix', T);
            else
                error('bad pose');
            end

            if nargout > 0
                h_ = h;
            end
        end

    end % static methods

end % classdef
