.data
msgCurrentSystem:  .asciiz "Enter the current system: "            
msgNumberInput:    .asciiz "Enter the number: "                    
msgNewSystem:      .asciiz "Enter the new system: "                
msgOutputNumber:   .asciiz "--------------------------------------\nThe number in the new system: "      
msgInvalidNumber:  .asciiz "Error: Invalid number for the system!\n" 
msgInvalidSystem:  .asciiz "Error: Invalid system, valid systems are [2, 16]\n"   
bufferLength:      .word   50                                      
inputBuffer:       .space  50                                      
outputBuffer:      .space  50                                      
currentSys:        .word   10                                      
newSys:            .word   10                                      

.text
main:
  la   $a0, msgCurrentSystem     
  jal  PrintAndReadInt                    
  sw   $v0, currentSys                 

  lw   $t0, currentSys                 
  blt  $t0, 2, InvalidSystem              
  bgt  $t0, 16, InvalidSystem             

  li   $v0, 4                             
  la   $a0, msgNumberInput            
  syscall                                 
  li   $v0, 8                             
  la   $a0, inputBuffer             
  lw   $a1, bufferLength                    
  syscall                                 

  la   $a0, inputBuffer             
  move $a1, $t0                           
  jal  ValidateInput                      

  la   $a0, msgNewSystem         
  jal  PrintAndReadInt                    
  sw   $v0, newSys                     

  lw   $t1, newSys                     
  blt  $t1, 2, InvalidSystem              
  bgt  $t1, 16, InvalidSystem             

  lw   $t0, currentSys                 
  beq  $t0, $t1, HandleEqualSystems
  beq  $t0, 10, CallDecimalToOther
  beq  $t1, 10, CallOtherToDecimal
  b    ConvertNonDecimalToNonDecimal

PrintAndReadInt:
  li   $v0, 4                             
  syscall                                 
  li   $v0, 5                             
  syscall                                 
  jr   $ra                                

ValidateInput:
  move $t0, $a1                           
  la   $t1, ($a0)                         
  lb   $t2, 0($t1)                        

  ValidateLoop:
  beqz $t2, EndValidation                 
  sub  $t3, $t2, '0'
  blt  $t3, $t0, ValidDigit
  bge  $t3, 10, CheckAlpha
  j    InvalidNumber

  CheckAlpha:
  sub  $t3, $t2, 'A'
  addi $t3, $t3, 10
  blt  $t3, $t0, ValidDigit
  j    InvalidNumber

  ValidDigit:
  addi $t1, $t1, 1                        
  lb   $t2, 0($t1)                        
  j    ValidateLoop

  InvalidNumber:
  li   $v0, 4                             
  la   $a0, msgInvalidNumber
  syscall
  li   $v0, 10                            
  syscall                                 

  EndValidation:
  jr   $ra                                

InvalidSystem:
  li   $v0, 4                             
  la   $a0, msgInvalidSystem	        
  syscall                                 
  li   $v0, 10                            
  syscall                                 

HandleEqualSystems:
  la   $a0, inputBuffer             
  la   $a1, outputBuffer            
  jal  CopyBuffer                         
  j    DisplayOutputAndExit               

CallDecimalToOther:
  la   $a0, inputBuffer             
  lw   $a1, newSys                     
  la   $a2, outputBuffer            
  jal  DecimalToOther                     
  j    DisplayOutputAndExit               

CallOtherToDecimal:
  la   $a0, inputBuffer             
  lw   $a1, currentSys                 
  la   $a2, outputBuffer            
  jal  OtherToDecimal                     
  j    DisplayOutputAndExit               

ConvertNonDecimalToNonDecimal:
  la   $a0, inputBuffer             
  lw   $a1, currentSys                 
  la   $a2, outputBuffer            
  jal  OtherToDecimal                     

  la   $a0, outputBuffer            
  la   $a1, inputBuffer             
  jal  CopyBuffer                         

  la   $a0, inputBuffer             
  lw   $a1, newSys                     
  la   $a2, outputBuffer            
  jal  DecimalToOther                     
  j    DisplayOutputAndExit               

CopyBuffer:
  move $t3, $a0                           
  move $t4, $a1                           

  CopyLoop:
  lb   $t5, 0($t3)                        
  sb   $t5, 0($t4)                        
  beqz $t5, EndLoop                       
  addi $t3, $t3, 1                        
  addi $t4, $t4, 1                        
  j    CopyLoop

  EndLoop:
  jr   $ra

DecimalToOther:
  la   $t0, ($a0)                         
  la   $t3, ($a2)                         
  la   $t4, ($a2)                         
  li   $t1, 0                             

  StringToDecimal:
  lb   $t2, 0($t0)                        
  beq  $t2, 10, DecimalDone               
  beqz $t2, DecimalDone                   
  subi $t2, $t2, '0'                      
  mul  $t1, $t1, 10                       
  add  $t1, $t1, $t2                      
  addi $t0, $t0, 1                        
  j    StringToDecimal                    
  DecimalDone:

  move $t2, $a1                           

  LoopDecimalToOther:
  beqz $t1, EndDecimalToOther             
  div  $t5, $t1, $t2                      
  mfhi $t6                                
  move $t1, $t5                           
  blt  $t6, 10, ConvertDigit              
  addi $t6, $t6, 55                       
  j    StoreChar

  ConvertDigit:
  addi $t6, $t6, 48                       

  StoreChar:
  sb   $t6, 0($t3)                        
  addi $t3, $t3, 1                        
  j    LoopDecimalToOther

  EndDecimalToOther:
  sb   $zero, 0($t3)                      
  subi $t3, $t3, 1                        

  ReverseLoop:
  lb   $t5, 0($t3)                        
  lb   $t6, 0($t4)                        
  sb   $t5, 0($t4)                        
  sb   $t6, 0($t3)                        
  addi $t4, $t4, 1                        
  subi $t3, $t3, 1                        
  blt  $t4, $t3, ReverseLoop              

  EndReverse:
  jr   $ra                                

OtherToDecimal:
  la   $t0, ($a0)                         
  move $t1, $a1                           
  la   $t5, ($a2)                         
  li   $t3, 0                             

  LoopOtherToDecimal:
  lb   $t4, 0($t0)                        
  beq  $t4, 10, EndConversion             
  beqz $t4, EndConversion                 
  subi $t4, $t4, '0'                      
  blt  $t4, 10, DigitConversion           
  subi $t4, $t4, 7                        
  
  DigitConversion:
  mul  $t3, $t3, $t1                      
  add  $t3, $t3, $t4                      
  addi $t0, $t0, 1                        
  j    LoopOtherToDecimal                 
  EndConversion:

  li   $t2, 10                            

  CountDigits:
  addi $t5, $t5, 1                        
  blt  $t3, $t2, SetupWriting             
  mul  $t2, $t2, 10                       
  j    CountDigits

  SetupWriting:
  li   $t2, 10                            
  sb   $zero, 0($t5)                      
  subi $t5, $t5, 1                        

  WriteDigits:
  beqz $t3, EndOtherToDecimal             
  div  $t3, $t3, $t2                      
  mfhi $t1                                
  addi $t1, $t1, '0'                      
  sb   $t1, 0($t5)                        
  subi $t5, $t5, 1                        
  j    WriteDigits
  
  EndOtherToDecimal:
  jr   $ra                                

DisplayOutputAndExit:
  li   $v0, 4                             
  la   $a0, msgOutputNumber           
  syscall                                 
  li   $v0, 4                             
  la   $a0, outputBuffer            
  syscall                                 
  li   $v0, 10                            
  syscall                                 
