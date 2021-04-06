% MIT License
% 
% Copyright (c) 2021 Qiu Yining
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%
% MIT License
% 
% Copyright (c) 2016 Vincent Bazia
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
% 
% Copyright (c) 2014, Mingjing Zhang
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the Simon Fraser University nor the names
%       of its contributors may be used to endorse or promote products derived
%       from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

function FlappyLearning
%% Matrix References

    % Bird & Pipe
    xColumn         = 1;
    yColumn         = 2;
    widthColumn     = 3;
    heightColumn    = 4;
    aliveColumn     = 5;
    speedColumn     = 5;
    gravityColumn   = 6;
    velocityColumn  = 7;
    jumpColumn      = 8;
    pipeUp          = true; 
    pipeBottom      = false;
    
    % Variable Delclaration
    NeuroEvo.network = [2,2,1];
    Game.maxScore = 0;
    FPS = 60;
    imBackground    = imread('img/background.png');
    [imBird,~,alphaChannelBird]          = imread('img/bird.png');
    [imPipetop,~,alphaChannelPipeTop]       = imread('img/pipetop.png');
    [imPipebottom,~,alphaChannelPipeBottom]    = imread('img/pipebottom.png'); 
    MainCanvas          = [];
    MainAxes            = [];
    ButtonCanvas        = [];
    ButtonAxes          = [];
    background          = [];
    background4button   = [];
    ButtonInfo          = [];
    FPSbutton           = [];
    pipetop             = [];
    pipebottom          = [];
    birds               = [];
    Score               = [];
    MaxScore            = [];
    Generation          = [];
    Alives              = [];
    CloseReq            = false;
    
    % Variable Initialization
    initVariables;
    initWindow;
    
    function initWindow
        MainCanvas = figure('Name', 'Flappy Learning', ...
            'NumberTitle', 'off', ...
            'Units', 'pixels', ...
            'Position', [500,300,Game.width,Game.height], ...
            'Renderer', 'OpenGL',...
            'Color',[0 0 0],...
            'Visible','on',...
            'CloseRequestFcn', @CloseReqFcn);
        
        MainAxes = axes('Parent',MainCanvas, ...
            'Units', 'pixels',...
            'Position', [0,0,Game.width,Game.height], ...
            'color', [0 0 0], ...
            'XLim', [0 Game.width], ...
            'YLim', [0 Game.height], ...
            'YDir', 'reverse', ...
            'NextPlot', 'add', ...
            'Visible', 'on', ...
            'XTick',0:10:500, ...
            'YTick',0:10:500,...
            'YTickMode','auto',...
            'YTickMode','auto');
        
        background = zeros(1,5);
        for i=1:5
            background(i) = image(imBackground,...
                'Parent', MainAxes,...
                'Visible', 'off');
        end
        
        pipetop = zeros(1,10);
        for i=1:10
            pipetop(i) = image(imPipetop,...
                'Parent', MainAxes,...
                'AlphaData', alphaChannelPipeTop,...
                'Visible', 'off');
        end
        
        pipebottom = zeros(1,10);
        for i=1:10
            pipebottom(i) = image(imPipebottom,...
                'Parent', MainAxes,...
                'AlphaData', alphaChannelPipeBottom,...
                'Visible', 'off');
        end
        
        birds = zeros(1,NeuroEvo.population);
        for i=1:NeuroEvo.population
            birds(i) = image(imBird,...
                'Parent', MainAxes,...
                'AlphaData', alphaChannelBird,...
                'Visible', 'off');
        end
        
        ButtonCanvas = uifigure('Name', 'Learning Speed', ...
            'NumberTitle', 'off', ...
            'Units', 'pixels', ...
            'Position', [1050,300,200,300], ...
            'Renderer', 'OpenGL',...
            'Color',[0 0 0],...
            'Visible','on',...
            'CloseRequestFcn', @CloseReqFcn);
        
        ButtonAxes = axes('Parent',ButtonCanvas, ...
            'Units', 'pixels',...
            'Position', [0,0,200,300], ...
            'color', [0 0 0], ...
            'XLim', [0 200], ...
            'YLim', [0 300], ...
            'YDir', 'reverse', ...
            'NextPlot', 'add', ...
            'Visible', 'on');
        
        background4button = image(imBackground,...
                'Parent', ButtonAxes,...
                'Visible', 'on',...
                'XData',0,...
                'YData',0);
          
        %ButtonInfo = text(20,50, 'Switch FPS','FontName', 'Helvetica','FontSize', 30,'Color',[1,1,1],'FontWeight', 'Bold', 'Visible', 'on');
        FPSbutton = zeros(1,5);
        FPSbutton(1) = uibutton(ButtonCanvas,'push','Position',[25, 50 + (1-1)*42, 150, 22],'Text','x0.5','ButtonPushedFcn',@FPSButtonPushedFcn1);
        FPSbutton(2) = uibutton(ButtonCanvas,'push','Position',[25, 50 + (2-1)*42, 150, 22],'Text','x1','ButtonPushedFcn',@FPSButtonPushedFcn2);
        FPSbutton(3) = uibutton(ButtonCanvas,'push','Position',[25, 50 + (3-1)*42, 150, 22],'Text','x2','ButtonPushedFcn',@FPSButtonPushedFcn3);
        FPSbutton(4) = uibutton(ButtonCanvas,'push','Position',[25, 50 + (4-1)*42, 150, 22],'Text','x3','ButtonPushedFcn',@FPSButtonPushedFcn4);
        FPSbutton(5) = uibutton(ButtonCanvas,'push','Position',[25, 50 + (5-1)*42, 150, 22],'Text','MAX','ButtonPushedFcn',@FPSButtonPushedFcn5);
        
        
        figure(MainCanvas);
        Score = text(10,10, '','FontName', 'Helvetica','FontSize', 20,'Color',[1,1,1],'FontWeight', 'Bold', 'Visible', 'on');
        MaxScore = text(10,36, '', 'FontName', 'Helvetica','FontSize', 20,'Color',[1,1,1],'FontWeight', 'Bold','Visible', 'on'); 
        Generation = text(10,62, '', 'FontName', 'Helvetica','FontSize', 20,'Color',[1,1,1],'FontWeight', 'Bold','Visible', 'on');
        Alives = text(10,88, '', 'FontName', 'Helvetica','FontSize', 20,'Color',[1,1,1],'FontWeight', 'Bold','Visible', 'on');
        
        
    end

    function displayMatrix(matrix,lines,columns)
    % displayMatrix(matrix,[2 3],[4 6]);
        if nargin == 3
            line = checkArray(lines);
            column = checkArray(columns);
        elseif nargin == 2
            line = checkArray(lines);
            column = checkArray(size(matrix,2));
        else
            line = checkArray(size(matrix,1));
            column = checkArray(size(matrix,2));
        end

    %     c = '';
    %     s = '';
    %     for j=column
    %         c=[c,'C  ',j,':'];
    %         s=[s,'%s%g%s'];
    %     end
    %     s=[s,'\n\n'];
    %     fprintf(s,c);

        for i=line
            s='';
            mat =[];
            for j=column
                s = [s,'%6.2f  '];
                mat = [mat,matrix(i,j)];
            end
            fprintf('%s%g%s','Line',i,': ');
            fprintf('%s','|');
            fprintf(s,mat);
            fprintf('%s\n','|');
        end

        function array = checkArray(input)
            array = [];
            if size(input,2) == 1
                for ii=1:input
                    array = [array,ii];
                end
            else
                for ii=input(1):input(2)
                    array = [array,ii];
                end
            end
        end

    end

%% Test zone--------------------------------------------
    %NeuroEvo.generations(1,1) = {[1,2,3,4,5,6,50;1,2,3,4,5,7,40]};
    %Game.generation = 1;
    %addGenome([1,2,3,4,5,6,444]);
    %mat = generateNextGeneration(1);
    %gen = firstGeneration();
    %generateBirds;
    %displayMatrix(NeuroEvo.generations{1,1});
    %fprintf('%g\n',networkCompute([3,7],1));
    
 %% Main--------------------------------------------   
    gameStart;
    gameUpdate;

%% Game Class

    function status = isItEnd
        status = true;
        if Game.alives
            status = false;
        end
    end

    function speed(fps)
        FPS = round(fps);
    end

    function FPSButtonPushedFcn1(hObject, eventdata, handles)
        speed(30);
    end

    function FPSButtonPushedFcn2(hObject, eventdata, handles)
        speed(60);
    end

    function FPSButtonPushedFcn3(hObject, eventdata, handles)
        speed(120);
    end


    function FPSButtonPushedFcn4(hObject, eventdata, handles)
        speed(180);
    end


    function FPSButtonPushedFcn5(hObject, eventdata, handles)
        speed(1000);
    end

    function CloseReqFcn(hObject, eventdata, handles)
        CloseReq = true;
    end

%% Game Class
    function gameStart
        
        Game.interval = 0;
        Game.score = 0;
        Game.birds = [];
        Game.pipes = [];
        NeuroEvo.prevGenome = NeuroEvo.genome;
        NeuroEvo.genome = [];
        Game.genome2add = [];
        
        nextGeneration;
        generateBirds;
        Game.generation = Game.generation + 1;
        Game.alives = countAliveBirds;
        
        if Game.regenerateFlag
            fprintf('%s\n','regenerateFlag: True')
            Game.regenerateFlag = false;
        end
        
        if ~Game.backgroundRefreshFlag
            for i=0:ceil(Game.width/288)
                set(background(i+1),...
                    'XData',i * 288 - floor(mod(0,288)),...
                    'YData',0,...
                    'Visible','on'); 
            end
        end
        
    end

    function gameUpdate
        Game.backgroundx = Game.backgroundx + Game.backgroundSpeed;
        nextHoll = 0;
        
        % prepare input parameters
        if countAliveBirds
            for i=1:2:countPipes
                if Game.pipes(i,xColumn)+Game.pipes(i,widthColumn) > Game.birds(1,xColumn)
                    nextHoll = Game.pipes(i,heightColumn)/Game.height;
                    break
                end
            end
        end
        
        for i=1:NeuroEvo.population
            if Game.birds(i,aliveColumn)
                inputs = [Game.birds(i,yColumn)/Game.height, nextHoll];
                res = networkCompute(inputs,i);
                if res > 0.5
                    birdFlap(i);
                end
                birdUpdate(i);
                if birdIsDead(i)
                    Game.birds(i,aliveColumn) = false;
                    Game.alives = Game.alives - 1;
                    Game.genome2add = [Game.genome2add;0,0,0,0,0,0,0];
                    Game.genome2add(NeuroEvo.population-Game.alives,:) = NeuroEvo.genome(i,:);
                    Game.genome2add(NeuroEvo.population-Game.alives,7) = Game.score;
                    
                    %fprintf('%g\n',Game.generation);
                    %displayMatrix(NeuroEvo.genome);
                    
                    if isItEnd
                        
                        if Game.maxScore < Game.minimumScoreLimit
                            Game.regenerateFlag = true;
                            
                        elseif Game.score < Game.minimumScoreLimit
                            Game.shitCount = Game.shitCount + 1;
                        end
                        
                        if Game.shitCount > 20
                            Game.shitCount = 0;
                            Game.regenerateFlag = true;
                        end
                        
                        for j=1:NeuroEvo.population
                            addGenome(Game.genome2add(j,:));
                        end
                        displayMatrix(NeuroEvo.genome,[1 50]);
                        
                        gameStart;
                        
                    end
                end
            end
        end

        % Update and check existing pipes
        for k=1:countPipes
            pipeUpdate(k);
        end
        
        for k=countPipes:-1:1
            if pipeIsOut(k)
                deletePipe(k);    
            end
        end
        
        if Game.interval == 0
            pipeDistance = 120;
            marginSafe = 80 + pipeDistance / 2;
            
            midPosition = rand * (marginSafe * 2 - Game.height) + Game.height - marginSafe;
            
            fprintf('%s','Pipe mid pos:    ');pr(round(midPosition));
            
            pipeUpPosition = round(midPosition - pipeDistance / 2);
            pipeBottomPosition = round(midPosition + pipeDistance / 2);
            
            addPipe(pipeUp,pipeUpPosition);
            addPipe(pipeBottom,pipeBottomPosition);

        end
        
        Game.interval = Game.interval + 1;
        if Game.interval == Game.spawnInterval
            Game.interval = 0;
        end
        
        Game.score = Game.score + 1;
        if Game.score > Game.maxScore
            Game.maxScore = Game.score;
            %fprintf('%g\n',Game.maxScore);
        end
        
%% Update Display ====================================================
        if Game.backgroundRefreshFlag
            for i=0:ceil(Game.width/288)
                set(background(i+1),...
                    'XData',i * 288 - floor(mod(Game.backgroundx,288)),...
                    'YData',0,...
                    'Visible','on'); 
            end
        end
        
        % reset visibility
        for i=1:NeuroEvo.population
            if i<11
                set(pipetop(i),'Visible','off');
                set(pipebottom(i),'Visible','off');
            end
            set(birds(i),'Visible','off');
        end
        
        % set new frame
        for i=1:countPipes
            if mod(i,2)==1
                set(pipetop(i),...
                    'XData',Game.pipes(i,1),...
                    'YData',Game.pipes(i,2),...
                    'Visible','on');
            else
                set(pipebottom(i),...
                    'XData',Game.pipes(i,1),...
                    'YData',Game.pipes(i,2),...
                    'Visible','on');
            end
        end
        
        for i=1:NeuroEvo.population
            if Game.birds(i,aliveColumn) 
                set(birds(i),'XData',Game.width/2,'YData',Game.birds(i,2),'Visible','on');
            end
        end    
        
        set(Score,'String',sprintf('Score: %g',Game.score));
        set(MaxScore,'String',sprintf('Max Score: %g',Game.maxScore));
        set(Generation,'String',sprintf('Generation: %g',Game.generation));
        set(Alives,'String',sprintf('Alive: %g',Game.alives));
        
        drawnow;
%% Wait for Next Frame ===============================================
        if CloseReq    
            delete(MainCanvas);
            delete(ButtonCanvas);
            return;
        end
        
        startTime = tic;
        
        while toc(startTime) < 1/FPS
        end
        
        gameUpdate;
    end

%% Pipe Class
    function addPipe(upordown,height)
        % pipe image = [512 40]
        if upordown %up
            y = height - 512;
        else
            y = height;
        end
        Game.pipes = [Game.pipes;Game.width,y,40,height,3];
    end

    function deletePipe(index)
        Game.pipes(index,:) = [];
    end
    
    function pipeUpdate(index)
        Game.pipes(index,xColumn) = Game.pipes(index,xColumn) - Game.pipes(index,speedColumn);
    end

    function status = pipeIsOut(index)
        status = false;
        if (Game.pipes(index,xColumn) + Game.pipes(index,widthColumn)) < 0
            status = true;
        end
    end
    
    function pipes = countPipes()
        pipes = size(Game.pipes,1);
    end
    
%% Bird Class
    function generateBirds()
        for i=1:NeuroEvo.population
            Game.birds = [Game.birds;Game.width/2,Game.height/2,34,24,true,0,0.3,-6];
        end
    end

    function birdFlap(index)
        Game.birds(index,gravityColumn) = Game.birds(index,jumpColumn);
    end

    function birdUpdate(index)
        Game.birds(index,gravityColumn) = Game.birds(index,gravityColumn) + Game.birds(index,velocityColumn);
        Game.birds(index,yColumn) = Game.birds(index,yColumn) + Game.birds(index,gravityColumn);
        %pr(Game.birds(1,yColumn));
    end

    function status = birdIsDead(index)
        status = false;
        if Game.birds(index,yColumn) <= 0 || ...
                Game.birds(index,yColumn) + Game.birds(index,heightColumn) >= Game.height
            status = true;
        end
        
        for i=1:countPipes
            if mod(i,2) == 1    %up
                if Game.birds(index,xColumn) + Game.birds(index,widthColumn) > Game.pipes(i,xColumn) && ...
                        Game.birds(index,xColumn) < Game.pipes(i,xColumn) + Game.pipes(i,widthColumn) && ...
                        Game.birds(index,yColumn) < Game.pipes(i,heightColumn)
                    status = true;
                end
            else                %bottom
                if Game.birds(index,xColumn) + Game.birds(index,widthColumn) > Game.pipes(i,xColumn) && ...
                        Game.birds(index,xColumn) < Game.pipes(i,xColumn) + Game.pipes(i,widthColumn) && ...
                        Game.birds(index,yColumn) + Game.birds(index,heightColumn) > Game.pipes(i,heightColumn)
                    status = true;
                end
            end
        end
    end

    function alives = countAliveBirds()
        alives = 0;
        for i=1:NeuroEvo.population
            if Game.birds(i,aliveColumn)
                alives = alives + 1;
            end
        end
    end
%% Variable Initialization
    function initVariables()
        NeuroEvo.network = [2,2,1];
        NeuroEvo.population = 50;
        NeuroEvo.elitism = 0.2;
        NeuroEvo.randomBehaviour = 0.2;
        NeuroEvo.mutationRate = 0.1;
        NeuroEvo.mutationRange = 0.5;
        NeuroEvo.scoreSort = -1;
        NeuroEvo.genome = [];  % [1 7] array, column 1~6 = weights, column 7 = score, line = genomes
        NeuroEvo.genome2add = [];
        NeuroEvo.prevGenome = [];
        
        Game.score = 0;
        Game.maxScore = 0;
        Game.width = 500;
        Game.height = 512;
        Game.spawnInterval = 70;
        Game.interval = 0;
        Game.generation = 0;
        Game.alives = 0;
        Game.backgroundSpeed = 0.5;
        Game.backgroundx = 0;
        Game.birds = [];
        Game.pipes = [];
        Game.minimumScoreLimit = 105;
        Game.shitCount = 0;
        Game.regenerateFlag = false;
        Game.backgroundRefreshFlag = false;
    end

%% Neural Evolution Functions

    function output = activation(i) % logistic activation
        i = (-i) / 1;
        output = 1 / (1 + exp(i));
    end

    function output = randomClamped
        output = rand * 2 - 1;
    end % generate random real number in [-1,1]

    function result = networkCompute(inputs,index)
        % input layer
        inputLayer = inputs;
        %hidden layer
        hiddenLayer = [0 0];
        for i=1:2
            sum = 0;
            for j=1:2
                sum = sum + inputLayer(j) * NeuroEvo.genome(index,(j+(i-1)*2));
            end
            hiddenLayer(i) = activation(sum);
        end
        %output layer
        sum = 0;
        for i=1:2
            sum = sum + hiddenLayer(i) * NeuroEvo.genome(index,i+4);
        end
        result = activation(sum);
    end
    
    function addGenome(genome)
        % input genome = [w1,w2,w3,w4,w5,w6,score] i.e. 1x7 matrix
        % current number of genomes
        nbGenomes=size(NeuroEvo.genome,1);
        % locate position
        endFlag = 0;
        for position=1:nbGenomes
            if NeuroEvo.scoreSort < 0
                if genome(1,7) > NeuroEvo.genome(position,7)
                    endFlag = 1;
                    break
                end
            else
                if genome(1,7) < NeuroEvo.genome(position,7)
                    endFlag = 1;
                    break
                end
            end
        end
        NeuroEvo.genome = [NeuroEvo.genome;0,0,0,0,0,0,0];
        if endFlag==0
           % insert new genome
            for i=1:7
                    NeuroEvo.genome(position+1,i)=genome(1,i);
            end
        else
            % make space for new genome
            for i=nbGenomes:-1:position
                for j=1:7
                    NeuroEvo.genome(i+1,j) = NeuroEvo.genome(i,j);
                end
            end
            % insert new genome
            for i=1:7
                    NeuroEvo.genome(position,i)=genome(1,i);
            end
        end
    end

    function newGenome = breedGenome(g1,g2)
        newGenome = g1;
        newGenome(1,7)=0;
        % genetic crossover
        for i=1:6
            if rand<=0.5
                newGenome(i)=g2(i);
            end
        end
        % perform mutation on some weights
        for i=1:6
            if rand <= NeuroEvo.mutationRate
                newGenome(i) = newGenome(i) + randomClamped * NeuroEvo.mutationRange;
            end
        end
    end

    function nexts = generateNextGeneration
        nexts = [];
        
        % elites
        for i=1:round(NeuroEvo.population * NeuroEvo.elitism)
            nexts = [nexts;0,0,0,0,0,0,0];
            nexts(i,:) = NeuroEvo.prevGenome(i,:);
        end
        
        % randoms
        for i=1:round(NeuroEvo.randomBehaviour * NeuroEvo.population)
            genome = [0,0,0,0,0,0,0];
            % randomize
            for k=1:6
                genome(k)=randomClamped;
            end
            nbGenomes = NeuroEvo.population * NeuroEvo.elitism+i;
            nexts = [nexts;0,0,0,0,0,0,0];
            nexts(nbGenomes,:)=genome;
        end
        
        % breed
        max = 1;
        loopFlag=1;
        while loopFlag==1
            for i=1:max
                childs = breedGenome(NeuroEvo.prevGenome(i,:),NeuroEvo.prevGenome(max,:));
                nbGenomes = size(nexts,1);
                nexts = [nexts;0,0,0,0,0,0,0];
                nexts(nbGenomes+1,:) = childs;
                if size(nexts,1)>=NeuroEvo.population
                    loopFlag=0;
                end
            end
            max=max+1;
            if max>=size(NeuroEvo.prevGenome,1)
                max=1;
            end
        end
    end

    function first = generateFirstGeneration
        first=[];
        for i=1:NeuroEvo.population
            newLine = [];
            for j=1:6
                newLine = [newLine, randomClamped];
            end
            newLine = [newLine,0];
            first = [first;newLine];
        end
    end

    function nextGeneration()
        if Game.regenerateFlag
            NeuroEvo.genome = generateFirstGeneration;
        else
            if Game.generation
                NeuroEvo.genome = generateNextGeneration;
            else
                NeuroEvo.genome = generateFirstGeneration;
            end
        end
    end

end












