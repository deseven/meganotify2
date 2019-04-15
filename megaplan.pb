#PB_HTTP_NoSSLCheck = 4

UseMD5Fingerprint()
UseSHA1Fingerprint()

Structure megaplanContentAuthor
  id.i
  name.s
EndStructure

Structure megaplanContentSubject
  id.i
  name.s
  type.s
EndStructure

Structure megaplanContent
  subject.megaplanContentSubject
  text.s
  author.megaplanContentAuthor
EndStructure

Structure megaplanSubject
  id.i
  type.s
EndStructure

Structure megaplanNotification
  id.i
  subject.megaplanSubject
  content.s
  contentComment.megaplanContent
  timeCreated.s
  name.s
EndStructure

Structure megaplanNotifications
  List notifications.megaplanNotification()
EndStructure

Structure megaplanAuth
  Map status.s()
  Map Data.s()
EndStructure

Structure megaplanQuery
  Map status.s()
  Data.megaplanNotifications
EndStructure

Structure megaplanTask
  id.i
  Name.s
  Status.s
  Deadline.s
  Owner.s
  responsible.s
  favorite.s
  timeCreated.s
  message.s
EndStructure

Structure megaplanProject
  id.i
  Name.s
  Status.s
  Deadline.s
  Owner.s
EndStructure

Structure megaplanApprovals
  List tasks.megaplanTask()
  List projects.megaplanTask()
EndStructure

Structure megaplanQueryApp
  Map status.s()
  Data.megaplanApprovals
EndStructure

Procedure.s getTimestamp(now.i,timezone.s)
  Define day.s,month.s,TimeStamp.s
  Select DayOfWeek(now)
    Case 0
      day = "Sun"
    Case 1
      day = "Mon"
    Case 2
      day = "Tue"
    Case 3
      day = "Wed"
    Case 4
      day = "Thu"
    Case 5
      day = "Fri"
    Case 6
      day = "Sat"
    Default
      day = "NaN"
  EndSelect
  Select FormatDate("%mm",now)
    Case "01"
      month = "Jan"
    Case "02"
      month = "Feb"
    Case "03"
      month = "Mar"
    Case "04"
      month = "Apr"
    Case "05"
      month = "May"
    Case "06"
      month = "Jun"
    Case "07"
      month = "Jul"
    Case "08"
      month = "Aug"
    Case "09"
      month = "Sep"
    Case "10"
      month = "Oct"
    Case "11"
      month = "Nov"
    Case "12"
      month = "Dec"
    Default
      month = "NaN"
  EndSelect
  TimeStamp.s = day  + FormatDate(", %dd ",now) + month + FormatDate(" %yyyy %hh:%ii:%ss ",now) + timezone
  ProcedureReturn TimeStamp.s
EndProcedure

Procedure Hex2Dec (Array Out.a (1), Hex$)
   Protected i2, max = Len(Hex$)
   ReDim Out((max + 1) / 2)
   For i2 = 1 To max Step 2
      Out(i2 / 2) = Val("$" + Mid(Hex$, i2, 2))
   Next i2
EndProcedure

Procedure$ StringHMAC (PB_Cipher, Message$, Key$)
  #HMAC_BLOCKSIZE = 64 ; blocksize is 64 (bytes) when using one of the following hash functions: SHA-1, MD5, RIPEMD-128/160.
  
  ; First of all, convert key from string to binary
  ; If key is longer than block size, replace it with hash(key)
  Protected Dim key_bdata.a (#HMAC_BLOCKSIZE)
  If (StringByteLength(Key$, #PB_Ascii) > #HMAC_BLOCKSIZE)
    PokeS(@key_bdata(0), StringFingerprint(Key$, PB_Cipher), -1, #PB_Ascii | #PB_String_NoZero)
  Else
    PokeS(@key_bdata(0), Key$, -1, #PB_Ascii | #PB_String_NoZero)
  EndIf
  
  ; Now introduce o_key_pad/i_key_pad and XOR them with some magic numbers
  Protected Dim i_key_pad.a (0)
  Protected Dim o_key_pad.a (0)
  Protected Tmp
  CopyArray(key_bdata(), i_key_pad())
  CopyArray(key_bdata(), o_key_pad())
  For Tmp = 0 To #HMAC_BLOCKSIZE
    i_key_pad(Tmp) ! $36
    o_key_pad(Tmp) ! $5c
  Next Tmp
  
  ; At last, start hashing
  Protected Hash_i$, Hash_o$         ; there are two steps, those variables storing result for step 1 and 2
  Protected hHash                    ; handle to initiated hash routine
  Protected Dim TempRaw.a (0)        ; a temporary buffer for data transfer
  
  ; First, hash using i_key_pad() and data
  ReDim TempRaw(StringByteLength(Message$, #PB_Ascii))
  PokeS(@TempRaw(0), Message$, -1, #PB_Ascii | #PB_String_NoZero)
  hHash = StartFingerprint (#PB_Any, PB_Cipher)
  AddFingerprintBuffer (hHash, @i_key_pad(0), #HMAC_BLOCKSIZE)
  If ArraySize(TempRaw())
    AddFingerprintBuffer (hHash, @TempRaw(0), ArraySize(TempRaw()))
  EndIf
  Hash_i$ = FinishFingerprint(hHash)
  
  ; Finally, hash once more using o_key_pad() + result of previous hashing
  Hex2Dec(TempRaw(), Hash_i$)
  hHash = StartFingerprint (#PB_Any, PB_Cipher)
  AddFingerprintBuffer (hHash, @o_key_pad(0), #HMAC_BLOCKSIZE)
  AddFingerprintBuffer (hHash, @TempRaw(0), ArraySize(TempRaw()))
  Hash_o$ = FinishFingerprint(hHash)
  
  Protected *hs = Ascii(Hash_o$)
  Hash_o$ = Base64Encoder(*hs,MemorySize(*hs)-1) ; -1 to leave NUL behind
  FreeMemory(*hs)
  
  ProcedureReturn Hash_o$
EndProcedure

Procedure.s mega_auth(login.s,password.s,base_url.s,agent.s)
  Protected NewMap headers.s()
  Protected req.i,code.s,res.s
  Protected url.s = "https://" + base_url + "/BumsCommonApiV01/User/authorize.api"
  Protected post.s = "Login=" + login + "&Password=" + StringFingerprint(password,#PB_Cipher_MD5,0,#PB_UTF8)
  headers("User-Agent") = agent
  
  req = HTTPRequest(#PB_HTTP_Post,url,post,#PB_HTTP_NoSSLCheck,headers())
  If req
    code = HTTPInfo(req,#PB_HTTP_StatusCode)
    res = HTTPInfo(req,#PB_HTTP_Response)
    ;Debug code
    ;Debug res
    FinishHTTP(req)
    Select code
      Case "401","403"
        ProcedureReturn "0"
      Case "0"
        ProcedureReturn "-1"
      Default
        ProcedureReturn res
    EndSelect
  EndIf
  ProcedureReturn "-1"
EndProcedure

Procedure.s mega_query(access_id.s,secret_key.s,query.s,base_url.s,timezone.s,agent.s)
  Protected NewMap headers.s()
  Protected req.i,code.s,res.s
  Protected now.i = Date()
  Protected url.s = "https://" + base_url + query
  Protected signature.s = "GET" + #LF$ + #LF$ + #LF$ + getTimestamp(now,timezone) + #LF$ + base_url + query
  
  signature = StringHMAC(#PB_Cipher_SHA1,signature,secret_key)
  
  headers("User-Agent") = agent
  headers("Date") = getTimestamp(now,timezone)
  headers("Accept") = "application/json"
  headers("X-Authorization") = access_id + ":" + signature
  headers("Content-Type") = "" ; apparently this is important
  headers("Content-Length") = "0"
  
  req = HTTPRequest(#PB_HTTP_Get,url,"",#PB_HTTP_NoSSLCheck,headers())
  If req
    code = HTTPInfo(req,#PB_HTTP_StatusCode)
    res = HTTPInfo(req,#PB_HTTP_Response)
    Debug code
    Debug res
    FinishHTTP(req)
    Select code
      Case "401","403"
        ProcedureReturn "0"
      Case "0"
        ProcedureReturn "-1"
      Default
        ProcedureReturn res
    EndSelect
  EndIf
  ProcedureReturn "-1"
EndProcedure

;Procedure.s mega_comparedates(date1.s,date2.s)
  
;EndProcedure
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; CursorPosition = 244
; FirstLine = 224
; Folding = -
; EnableXP