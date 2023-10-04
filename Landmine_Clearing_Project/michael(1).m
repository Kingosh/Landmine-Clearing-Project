d = daq.getDevices
s = daq.createSession('ni') 
s1 = daq.createSession('ni') 
s2 = daq.createSession('ni') 
s3 = daq.createSession('ni') 
s4 = daq.createSession('ni') 
s5 = daq.createSession('ni') 

s6 = daq.createSession('ni')

addDigitalChannel(s,'myDAQ1','Port0/Line6:7','OutputOnly')%motor-left
 addDigitalChannel(s1,'myDAQ1','Port0/Line4:5','OutputOnly')%motor-right
 addAnalogOutputChannel(s2,'myDAQ1','ao0','Voltage') %servo-1 
 addAnalogInputChannel(s3,'myDAQ1','ai0','Voltage')%IR-Puck
addAnalogInputChannel(s3,'myDAQ1','ai1','Voltage')%line-detection IR
 addDigitalChannel(s5,'myDAQ1','Port0/Line0','InputOnly')%micro-switch-left
 addDigitalChannel(s6,'myDAQ1','Port0/Line1','InputOnly')%micro-switch
 
 %initial settings for servo and logics
 collectedpuck=0
 disp("collectedpuck")
 disp(collectedpuck)
 outputData = 0
  queueOutputData(s2, outputData);
  startForeground(s2);
  
  
  for  k=1:10000000
      %start
      data = inputSingleScan(s3)
      filtered=data
      IRfront=filtered(1,1)
      IRline=filtered(1,2)
              if IRfront<1 & collectedpuck <= 1 %collection
            disp("coll code")
            outputData = 5
        queueOutputData(s2, outputData); %collection servo position
         startForeground(s2);
         pause(0.5)
	          for i=1:2%front
              outputSingleScan(s,[0, 1])
              outputSingleScan(s1,[1, 0])
              pause(0.2)
              outputSingleScan(s,[0, 0])
              outputSingleScan(s1,[0, 0])
              pause(0.5)
              end
		outputData = 0
        queueOutputData(s2, outputData); %closinng servo position
         startForeground(s2);
         
		
		collectedpuck=collectedpuck+1
        end
        if IRline<1 & collectedpuck >= 1 %drop off
            disp("linecode")
         for i=1:1
		outputSingleScan(s,[0,1])   %left
        outputSingleScan(s1,[0,1])
		pause(0.2)
        outputSingleScan(s,[0,0])   %left
        outputSingleScan(s1,[0,0])
		pause(0.4)
         end
		
          for i=1:1%front
  
              outputSingleScan(s,[0, 1])
              outputSingleScan(s1,[1, 0])
              pause(0.2)
              outputSingleScan(s,[0, 0])
              outputSingleScan(s1,[0, 0])
              pause(0.4)
          end
           outputData = 5 %servo drop off
        queueOutputData(s2, outputData); 
         startForeground(s2);
         for i=1:3
		 outputSingleScan(s,[1, 0])%back
         outputSingleScan(s1,[0, 1])
		 pause(0.2)
          outputSingleScan(s,[0, 0])%back
         outputSingleScan(s1,[0, 0])
		 pause(0.4)
         end
         outputData = 0
        queueOutputData(s2, outputData); 
         startForeground(s2);
         pause(0.3)
         for i=1:4%front
  
              outputSingleScan(s,[0, 1])
              outputSingleScan(s1,[1, 0])
              pause(0.1)
              outputSingleScan(s,[0, 0])
              outputSingleScan(s1,[0, 0])
              pause(0.4)
         end
         
          for i=1:4
		 outputSingleScan(s,[1, 0])%back
         outputSingleScan(s1,[0, 1])
		 pause(0.2)
          outputSingleScan(s,[0, 0])%back
         outputSingleScan(s1,[0, 0])
		 pause(0.4)
         end
           for i=1:1   
		 outputSingleScan(s,[1,0]) %right
        outputSingleScan(s1,[1,0])
		pause(0.5)
         outputSingleScan(s,[1,0]) %right
        outputSingleScan(s1,[1,0])
		pause(0.5)
           end
        outputData = 0 
        queueOutputData(s2, outputData); 
         startForeground(s2);
		collectedpuck=0
		

        end
      if IRfront<3.8 & IRfront > 3.4%avoid black pucks
          for lr=1:3%back
         outputSingleScan(s,[1, 0])
         outputSingleScan(s1,[0, 1])
		 pause(0.2)
         outputSingleScan(s,[0, 0])
         outputSingleScan(s1,[0, 0])
         pause(0.4)
                end
                for b=1:2 %right
		outputSingleScan(s,[0,1])
        outputSingleScan(s1,[0,1])
		pause(0.2)
        outputSingleScan(s,[0, 0])
         outputSingleScan(s1,[0, 0])
         pause(0.4)
                end
          
      end
      		if inputSingleScan(s5)==1 %left switch
                for lr=1:3%back
         outputSingleScan(s,[1, 0])
         outputSingleScan(s1,[0, 1])
		 pause(0.2)
         outputSingleScan(s,[0, 0])
         outputSingleScan(s1,[0, 0])
         pause(0.4)
                end
                for b=1:2 %right
		outputSingleScan(s,[0,1])
        outputSingleScan(s1,[0,1])
		pause(0.2)
        outputSingleScan(s,[0, 0])
         outputSingleScan(s1,[0, 0])
         pause(0.4)
                end
        
		elseif inputSingleScan(s6)==1 %right switch
             for lr=1:3%back
         outputSingleScan(s,[1, 0])
         outputSingleScan(s1,[0, 1])
		 pause(0.2)
         outputSingleScan(s,[0, 0])
         outputSingleScan(s1,[0, 0])
         pause(0.4)
             end
                for i=1:2 %left
		outputSingleScan(s,[1,0])
        outputSingleScan(s1,[1,0])
		pause(0.2)
        outputSingleScan(s,[0,0])
        outputSingleScan(s1,[0,0])
		pause(0.4)
                end
        else
		
		      for i=1:2%foward
  
              outputSingleScan(s,[0, 1])
              outputSingleScan(s1,[1, 0])
              pause(0.2)
              outputSingleScan(s,[0, 0])
              outputSingleScan(s1,[0, 0])
              pause(0.4)
              
              
        end
       end

  end