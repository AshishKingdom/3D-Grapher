'##############################################################################################
'3D Grapher By Ashish Kushwaha
'----------------------------------------------------------------------------------------------
'* Thanks to STxAxTIC. Without his sxript, coding this would be harder.
'* Thanks to FellipeHeitor. His INPUTBOX() come handy when I need QB64 Input & OpenGL together.
'----------------------------------------------------------------------------------------------
'Description: Give an expression for z = ... containing terms of x, y (any power) & constants
'With the power of sxript, it also support *trigonometric functions* in the expression.
'Click on Ok. Then the Graph is plotted in 3D Space & shown in 2D screen.
'-----------------------------------------------------------------------------------------------
'Controls:
'* Drag on screen with mouse for rotation.
'* Mousewheel for zooming in or zooming out.
'* Right click to plot new graph.
'* Hit SPACE to switch between rendering modes.
'----------------------------------------------------------------------------------------------
'Friday the 13th March, 2020
'----------------------------------------------------------------------------------------------
'UPDATED : 16 March, 2020
'added sgn() signum and abs() absolute value function
'also added zooming feature and ability to plot new graph without running the app again.
'UPDATED : 20 January, 2021
'Added support to switch between solid surface render mode and lines render mode

'$INCLUDE:'sxript.bi'

DECLARE LIBRARY
    SUB gluLookAt (BYVAL eyeX#, BYVAL eyeY#, BYVAL eyeZ#, BYVAL centerX#, BYVAL centerY#, BYVAL centerZ#, BYVAL upX#, BYVAL upY#, BYVAL upZ#)
END DECLARE

TYPE rgb
    r AS SINGLE
    g AS SINGLE
    b AS SINGLE
END TYPE
TYPE vec3
    x as SINGLE
    y as SINGLE
    z as SINGLE
END TYPE
TYPE vertex_type
    pos as vec3
    clr as rgb
END TYPE
DIM SHARED vert(100, 100), glAllow, xRot, yRot, colArr(100, 100) AS rgb, init
DIM SHARED scaleFactor, graph_render_mode
scaleFactor = 1.0

_TITLE "3D Grapher"
SCREEN _NEWIMAGE(600, 600, 32)
a$ = SxriptEval("func(abs,{unquote(quote([x])/`-')})") 'hack for abs() function by STxAxTIC
a$ = SxriptEval("func(sgn,{sub({let(a,[x]*1):print_iff([a]=0,{0},{iff(greater([a],0),{1},{-1})})})})") 'signum function by STxAxTIC
start:
dummy = INPUTBOX("Enter the expression for Z = ", "Enter the expression for Z = (ex. X*Y)", "X+Y-1", e$, -1)
IF dummy = 2 THEN SYSTEM
' for i = 1 to len(e$)
' ca$ = mid$(e$,i,1)
' if lcase$(ca$) = "x" then ca$= "[x]"
' if lcase$(ca$) = "y" then ca$= "[y]"
' ex$ = ex$+ca$
' next
' a$ = SxriptEval("func(plot,{"+ex$+"})")
CLS
PRINT "Generating... Just a moment"
_DISPLAY

FOR x = -50 TO 50
    FOR z = -50 TO 50
        expression$ = ""
        FOR i = 1 TO LEN(e$)
            ca$ = MID$(e$, i, 1)
            IF LCASE$(ca$) = "x" THEN ca$ = _TRIM$(STR$(x / 10))
            IF LCASE$(ca$) = "y" THEN ca$ = _TRIM$(STR$(z / 10))
            expression$ = expression$ + ca$
        NEXT
        vert(x + 50, z + 50) = VAL(SxriptEval(expression$)) 'replace x & y with actual numeric value & then evaluate with sxript.
        'PRINT expression$, VAL(SxriptEval(expression$))
        'SLEEP
        IF init = 0 THEN 'storage of color per vertex need not done again & again.
            c~& = hsb(map(z, -50, 50, 0, 255), 255, 128, 255)
            colArr(x + 50, z + 50).r = _RED(c~&) / 255
            colArr(x + 50, z + 50).g = _GREEN(c~&) / 255
            colArr(x + 50, z + 50).b = _BLUE(c~&) / 255
        END IF
    NEXT
NEXT

CLS , 1 'display the equation.
COLOR , 1
PRINT "Z = " + e$
_DISPLAY
_GLRENDER _BEHIND
graph_render_mode = 1' 1=solid surface, -1=lines
glAllow = 1
init = 1
'SLEEP
DO
    WHILE _MOUSEINPUT
        IF scaleFactor > 0.1 THEN 'to prevent negative value
            scaleFactor = scaleFactor + _MOUSEWHEEL * 0.05
        ELSE
            scaleFactor = 0.11 'so it's value can still be change.
        END IF
    WEND
    IF _MOUSEBUTTON(1) THEN
        x = _MOUSEX: y = _MOUSEY
        WHILE _MOUSEBUTTON(1)
            WHILE _MOUSEINPUT: WEND
            yRot = yRot + (_MOUSEX - x) 'rotate by change
            xRot = xRot + (_MOUSEY - y)
            x = _MOUSEX: y = _MOUSEY
        WEND
    END IF
    IF _MOUSEBUTTON(2) THEN
        glAllow = 0 'disbale GL rendering & clear screen.
        CLS
        GOTO start 'to take new input
    END IF
    k& = _KEYHIT
    if k&=32 then graph_render_mode = graph_render_mode*-1
    _LIMIT 60
LOOP

SUB _GL () STATIC
    IF glAllow = 0 THEN EXIT SUB

    _glClear _GL_COLOR_BUFFER_BIT OR _GL_DEPTH_BUFFER_BIT
    _glEnable _GL_DEPTH_TEST
    _glEnable _GL_BLEND


    _glMatrixMode _GL_PROJECTION
    _gluPerspective 50, 1, 0.1, 40

    _glMatrixMode _GL_MODELVIEW
    _glLoadIdentity

    gluLookAt 0, 7, 15, 0, 0, 0, 0, 1, 0
    _glRotatef xRot, 1, 0, 0
    _glRotatef yRot, 0, 1, 0
    
    _glScalef scaleFactor, scaleFactor, scaleFactor 'for zooming with mousewheel
    
    _glLineWidth 2.0
    'draw axis
    _glBegin _GL_LINES
    'x-axis
    _glColor3f 1, 0, 0
    _glVertex3f -5, 0, 0
    _glVertex3f 5, 0, 0
    'z-axis
    _glColor3f 0, 1, 0
    _glVertex3f 0, -5, 0
    _glVertex3f 0, 5, 0
    'y-axis
    _glColor3f 0, 0, 1
    _glVertex3f 0, 0, -5
    _glVertex3f 0, 0, 5

    _glEnd
    _glColor3f 1, 1, 1
    _glLineWidth 1.0
    'draw the surface according to stored height map evaluated before.
    FOR z = -50 TO 49
        if graph_render_mode = 1 then _glBegin _GL_TRIANGLE_STRIP else _glBegin _GL_LINE_STRIP
        FOR x = -50 TO 50
            _glColor4f colArr(x + 50, z + 50).r, colArr(x + 50, z + 50).g, colArr(x + 50, z + 50).b, 0.7
            _glVertex3f map(x, -50, 50, -5, 5), vert(x + 50, z + 50), map(z, -50, 50, 5, -5)
            _glVertex3f map(x, -50, 50, -5, 5), vert(x + 50, z + 51), map(z + 1, -50, 50, 5, -5)
        NEXT
        _glEnd
    NEXT


END SUB

'By Fellipe Heitor
FUNCTION INPUTBOX (tTitle$, tMessage$, InitialValue AS STRING, NewValue AS STRING, Selected)
    'INPUTBOX ---------------------------------------------------------------------
    'Show a dialog and allow user input. Returns 1 = OK or 2 = Cancel.            '
    '                                                                             '
    '- tTitle$ is the desired dialog title. If not provided, it'll be "Input"     '
    '                                                                             '
    '- tMessage$ is the prompt that'll be shown to the user. You can show         '
    '   a multiline message by adding line breaks with CHR$(10).                  '
    '                                                                             '
    ' - InitialValue can be passed both as a string literal or as a variable.     '
    '                                                                             '
    '- Actual user input is returned by altering NewValue, so it must be          '
    '   passed as a variable.                                                     '
    '                                                                             '
    '- Selected indicates wheter the initial value will be preselected when the   '
    '   dialog is first shown. -1 preselects the whole text; positive values      '
    '   select only part of the initial value (from the character position passed '
    '   to the end of the initial value).                                         '
    '                                                                             '
    'Intended for use with 32-bit screen modes.                                   '
    '------------------------------------------------------------------------------

    'Variable declaration:
    DIM Message$, Title$, CharW AS INTEGER, MaxLen AS INTEGER
    DIM lineBreak AS INTEGER, totalLines AS INTEGER, prevlinebreak AS INTEGER
    DIM Cursor AS INTEGER, Selection.Start AS INTEGER, InputViewStart AS INTEGER
    DIM FieldArea AS INTEGER, DialogH AS INTEGER, DialogW AS INTEGER
    DIM DialogX AS INTEGER, DialogY AS INTEGER, InputField.X AS INTEGER
    DIM TotalButtons AS INTEGER, B AS INTEGER, ButtonLine$
    DIM cb AS INTEGER, DIALOGRESULT AS INTEGER, i AS INTEGER
    DIM message.X AS INTEGER, SetCursor#, cursorBlink%
    DIM DefaultButton AS INTEGER, k AS LONG
    DIM shiftDown AS _BYTE, ctrlDown AS _BYTE, Clip$
    DIM FindLF%, s1 AS INTEGER, s2 AS INTEGER
    DIM Selection.Value$
    DIM prevCursor AS INTEGER, ss1 AS INTEGER, ss2 AS INTEGER, mb AS _BYTE
    DIM mx AS INTEGER, my AS INTEGER, nmx AS INTEGER, nmy AS INTEGER
    DIM FGColor AS LONG, BGColor AS LONG

    'Data type used for the dialog buttons:
    TYPE BUTTONSTYPE
        ID AS LONG
        CAPTION AS STRING * 120
        X AS INTEGER
        Y AS INTEGER
        W AS INTEGER
    END TYPE

    'Color constants. You can customize colors by changing these:
    CONST TitleBarColor = _RGB32(0, 178, 179)
    CONST DialogBGColor = _RGB32(255, 255, 255)
    CONST TitleBarTextColor = _RGB32(0, 0, 0)
    CONST DialogTextColor = _RGB32(0, 0, 0)
    CONST InputFieldColor = _RGB32(200, 200, 200)
    CONST InputFieldTextColor = _RGB32(0, 0, 0)
    CONST SelectionColor = _RGBA32(127, 127, 127, 100)

    'Initial variable setup:
    Message$ = tMessage$
    Title$ = RTRIM$(LTRIM$(tTitle$))
    IF Title$ = "" THEN Title$ = "Input"
    NewValue = RTRIM$(LTRIM$(InitialValue))
    DefaultButton = 1

    'Save the current drawing page so it can be restored later:
    FGColor = _DEFAULTCOLOR
    BGColor = _BACKGROUNDCOLOR
    PCOPY 0, 1

    'Figure out the print width of a single character (in case user has a custom font applied)
    CharW = _PRINTWIDTH("_")

    'Place a color overlay over the old screen image so the focus is on the dialog:
    LINE (0, 0)-STEP(_WIDTH - 1, _HEIGHT - 1), _RGBA32(170, 170, 170, 170), BF

    'Message breakdown, in case CHR$(10) was used as line break:
    REDIM MessageLines(1) AS STRING
    MaxLen = 1
    DO
        lineBreak = INSTR(lineBreak + 1, Message$, CHR$(10))
        IF lineBreak = 0 AND totalLines = 0 THEN
            totalLines = 1
            MessageLines(1) = Message$
            MaxLen = LEN(Message$)
            EXIT DO
        ELSEIF lineBreak = 0 AND totalLines > 0 THEN
            totalLines = totalLines + 1
            REDIM _PRESERVE MessageLines(1 TO totalLines) AS STRING
            MessageLines(totalLines) = RIGHT$(Message$, LEN(Message$) - prevlinebreak + 1)
            IF LEN(MessageLines(totalLines)) > MaxLen THEN MaxLen = LEN(MessageLines(totalLines))
            EXIT DO
        END IF
        IF totalLines = 0 THEN prevlinebreak = 1
        totalLines = totalLines + 1
        REDIM _PRESERVE MessageLines(1 TO totalLines) AS STRING
        MessageLines(totalLines) = MID$(Message$, prevlinebreak, lineBreak - prevlinebreak)
        IF LEN(MessageLines(totalLines)) > MaxLen THEN MaxLen = LEN(MessageLines(totalLines))
        prevlinebreak = lineBreak + 1
    LOOP

    Cursor = LEN(NewValue)
    Selection.Start = 0
    InputViewStart = 1
    FieldArea = _WIDTH \ CharW - 4
    IF FieldArea > 62 THEN FieldArea = 62
    IF Selected > 0 THEN Selection.Start = Selected: Selected = -1

    'Calculate dialog dimensions and print coordinates:
    DialogH = _FONTHEIGHT * (6 + totalLines) + 10
    DialogW = (CharW * FieldArea) + 10
    IF DialogW < MaxLen * CharW + 10 THEN DialogW = MaxLen * CharW + 10

    DialogX = _WIDTH / 2 - DialogW / 2
    DialogY = _HEIGHT / 2 - DialogH / 2
    InputField.X = (DialogX + (DialogW / 2)) - (((FieldArea * CharW) - 10) / 2) - 4

    'Calculate button's print coordinates:
    TotalButtons = 2
    DIM Buttons(1 TO TotalButtons) AS BUTTONSTYPE
    B = 1
    Buttons(B).ID = 1: Buttons(B).CAPTION = "< OK >": B = B + 1
    Buttons(B).ID = 2: Buttons(B).CAPTION = "< Cancel >": B = B + 1
    ButtonLine$ = " "
    FOR cb = 1 TO TotalButtons
        ButtonLine$ = ButtonLine$ + RTRIM$(LTRIM$(Buttons(cb).CAPTION)) + " "
        Buttons(cb).Y = DialogY + 5 + _FONTHEIGHT * (5 + totalLines)
        Buttons(cb).W = _PRINTWIDTH(RTRIM$(LTRIM$(Buttons(cb).CAPTION)))
    NEXT cb
    Buttons(1).X = _WIDTH / 2 - _PRINTWIDTH(ButtonLine$) / 2
    FOR cb = 2 TO TotalButtons
        Buttons(cb).X = Buttons(1).X + _PRINTWIDTH(SPACE$(INSTR(ButtonLine$, RTRIM$(LTRIM$(Buttons(cb).CAPTION)))))
    NEXT cb

    'Main loop:
    DIALOGRESULT = 0
    _KEYCLEAR
    DO: _LIMIT 500
        'Draw the dialog.
        LINE (DialogX, DialogY)-STEP(DialogW - 1, DialogH - 1), DialogBGColor, BF
        LINE (DialogX, DialogY)-STEP(DialogW - 1, _FONTHEIGHT + 1), TitleBarColor, BF
        COLOR TitleBarTextColor
        _PRINTSTRING (_WIDTH / 2 - _PRINTWIDTH(Title$) / 2, DialogY + 1), Title$

        COLOR DialogTextColor, _RGBA32(0, 0, 0, 0)
        FOR i = 1 TO totalLines
            message.X = _WIDTH / 2 - _PRINTWIDTH(MessageLines(i)) / 2
            _PRINTSTRING (message.X, DialogY + 5 + _FONTHEIGHT * (i + 1)), MessageLines(i)
        NEXT i

        'Draw the input field
        LINE (InputField.X - 2, DialogY + 3 + _FONTHEIGHT * (3 + totalLines))-STEP(FieldArea * CharW, _FONTHEIGHT + 4), InputFieldColor, BF
        COLOR InputFieldTextColor
        _PRINTSTRING (InputField.X, DialogY + 5 + _FONTHEIGHT * (3 + totalLines)), MID$(NewValue, InputViewStart, FieldArea)

        'Selection highlight:
        GOSUB SelectionHighlight

        'Cursor blink:
        IF TIMER - SetCursor# > .4 THEN
            SetCursor# = TIMER
            IF cursorBlink% = 1 THEN cursorBlink% = 0 ELSE cursorBlink% = 1
        END IF
        IF cursorBlink% = 1 THEN
            LINE (InputField.X + (Cursor - (InputViewStart - 1)) * CharW, DialogY + 5 + _FONTHEIGHT * (3 + totalLines))-STEP(0, _FONTHEIGHT), _RGB32(0, 0, 0)
        END IF

        'Check if buttons have been clicked or are being hovered:
        GOSUB CheckButtons

        'Draw buttons:
        FOR cb = 1 TO TotalButtons
            _PRINTSTRING (Buttons(cb).X, Buttons(cb).Y), RTRIM$(LTRIM$(Buttons(cb).CAPTION))
            IF cb = DefaultButton THEN
                COLOR _RGB32(255, 255, 0)
                _PRINTSTRING (Buttons(cb).X, Buttons(cb).Y), "<" + SPACE$(LEN(RTRIM$(LTRIM$(Buttons(cb).CAPTION))) - 2) + ">"
                COLOR _RGB32(0, 178, 179)
                _PRINTSTRING (Buttons(cb).X - 1, Buttons(cb).Y - 1), "<" + SPACE$(LEN(RTRIM$(LTRIM$(Buttons(cb).CAPTION))) - 2) + ">"
                COLOR _RGB32(0, 0, 0)
            END IF
        NEXT cb

        _DISPLAY

        'Process input:
        k = _KEYHIT
        IF k = 100303 OR k = 100304 THEN shiftDown = -1
        IF k = -100303 OR k = -100304 THEN shiftDown = 0
        IF k = 100305 OR k = 100306 THEN ctrlDown = -1
        IF k = -100305 OR k = -100306 THEN ctrlDown = 0

        SELECT CASE k
            CASE 13: DIALOGRESULT = 1
            CASE 27: DIALOGRESULT = 2
            CASE 32 TO 126 'Printable ASCII characters
                IF k = ASC("v") OR k = ASC("V") THEN 'Paste from clipboard (Ctrl+V)
                    IF ctrlDown THEN
                        Clip$ = _CLIPBOARD$
                        FindLF% = INSTR(Clip$, CHR$(13))
                        IF FindLF% > 0 THEN Clip$ = LEFT$(Clip$, FindLF% - 1)
                        FindLF% = INSTR(Clip$, CHR$(10))
                        IF FindLF% > 0 THEN Clip$ = LEFT$(Clip$, FindLF% - 1)
                        IF LEN(RTRIM$(LTRIM$(Clip$))) > 0 THEN
                            IF NOT Selected THEN
                                IF Cursor = LEN(NewValue) THEN
                                    NewValue = NewValue + Clip$
                                    Cursor = LEN(NewValue)
                                ELSE
                                    NewValue = LEFT$(NewValue, Cursor) + Clip$ + MID$(NewValue, Cursor + 1)
                                    Cursor = Cursor + LEN(Clip$)
                                END IF
                            ELSE
                                s1 = Selection.Start
                                s2 = Cursor
                                IF s1 > s2 THEN SWAP s1, s2
                                NewValue = LEFT$(NewValue, s1) + Clip$ + MID$(NewValue, s2 + 1)
                                Cursor = s1 + LEN(Clip$)
                                Selected = 0
                            END IF
                        END IF
                        k = 0
                    END IF
                ELSEIF k = ASC("c") OR k = ASC("C") THEN 'Copy selection to clipboard (Ctrl+C)
                    IF ctrlDown THEN
                        _CLIPBOARD$ = Selection.Value$
                        k = 0
                    END IF
                ELSEIF k = ASC("x") OR k = ASC("X") THEN 'Cut selection to clipboard (Ctrl+X)
                    IF ctrlDown THEN
                        _CLIPBOARD$ = Selection.Value$
                        GOSUB DeleteSelection
                        k = 0
                    END IF
                ELSEIF k = ASC("a") OR k = ASC("A") THEN 'Select all text (Ctrl+A)
                    IF ctrlDown THEN
                        Cursor = LEN(NewValue)
                        Selection.Start = 0
                        Selected = -1
                        k = 0
                    END IF
                END IF

                IF k > 0 THEN
                    IF NOT Selected THEN
                        IF Cursor = LEN(NewValue) THEN
                            NewValue = NewValue + CHR$(k)
                            Cursor = Cursor + 1
                        ELSE
                            NewValue = LEFT$(NewValue, Cursor) + CHR$(k) + MID$(NewValue, Cursor + 1)
                            Cursor = Cursor + 1
                        END IF
                        IF Cursor > FieldArea THEN InputViewStart = (Cursor - FieldArea) + 2
                    ELSE
                        s1 = Selection.Start
                        s2 = Cursor
                        IF s1 > s2 THEN SWAP s1, s2
                        NewValue = LEFT$(NewValue, s1) + CHR$(k) + MID$(NewValue, s2 + 1)
                        Selected = 0
                        Cursor = s1 + 1
                    END IF
                END IF
            CASE 8 'Backspace
                IF LEN(NewValue) > 0 THEN
                    IF NOT Selected THEN
                        IF Cursor = LEN(NewValue) THEN
                            NewValue = LEFT$(NewValue, LEN(NewValue) - 1)
                            Cursor = Cursor - 1
                        ELSEIF Cursor > 1 THEN
                            NewValue = LEFT$(NewValue, Cursor - 1) + MID$(NewValue, Cursor + 1)
                            Cursor = Cursor - 1
                        ELSEIF Cursor = 1 THEN
                            NewValue = RIGHT$(NewValue, LEN(NewValue) - 1)
                            Cursor = Cursor - 1
                        END IF
                    ELSE
                        GOSUB DeleteSelection
                    END IF
                END IF
            CASE 21248 'Delete
                IF NOT Selected THEN
                    IF LEN(NewValue) > 0 THEN
                        IF Cursor = 0 THEN
                            NewValue = RIGHT$(NewValue, LEN(NewValue) - 1)
                        ELSEIF Cursor > 0 AND Cursor <= LEN(NewValue) - 1 THEN
                            NewValue = LEFT$(NewValue, Cursor) + MID$(NewValue, Cursor + 2)
                        END IF
                    END IF
                ELSE
                    GOSUB DeleteSelection
                END IF
            CASE 19200 'Left arrow key
                GOSUB CheckSelection
                IF Cursor > 0 THEN Cursor = Cursor - 1
            CASE 19712 'Right arrow key
                GOSUB CheckSelection
                IF Cursor < LEN(NewValue) THEN Cursor = Cursor + 1
            CASE 18176 'Home
                GOSUB CheckSelection
                Cursor = 0
            CASE 20224 'End
                GOSUB CheckSelection
                Cursor = LEN(NewValue)
        END SELECT

        'Cursor adjustments:
        GOSUB CursorAdjustments
    LOOP UNTIL DIALOGRESULT > 0

    _KEYCLEAR
    INPUTBOX = DIALOGRESULT

    'Restore previous display:
    PCOPY 1, 0
    COLOR FGColor, BGColor
    EXIT SUB

    CursorAdjustments:
    IF Cursor > prevCursor THEN
        IF Cursor - InputViewStart + 2 > FieldArea THEN InputViewStart = (Cursor - FieldArea) + 2
    ELSEIF Cursor < prevCursor THEN
        IF Cursor < InputViewStart - 1 THEN InputViewStart = Cursor
    END IF
    prevCursor = Cursor
    IF InputViewStart < 1 THEN InputViewStart = 1
    RETURN

    CheckSelection:
    IF shiftDown = -1 THEN
        IF Selected = 0 THEN
            Selected = -1
            Selection.Start = Cursor
        END IF
    ELSEIF shiftDown = 0 THEN
        Selected = 0
    END IF
    RETURN

    DeleteSelection:
    NewValue = LEFT$(NewValue, s1) + MID$(NewValue, s2 + 1)
    Selected = 0
    Cursor = s1
    RETURN

    SelectionHighlight:
    IF Selected THEN
        s1 = Selection.Start
        s2 = Cursor
        IF s1 > s2 THEN
            SWAP s1, s2
            IF InputViewStart > 1 THEN
                ss1 = s1 - InputViewStart + 1
            ELSE
                ss1 = s1
            END IF
            ss2 = s2 - s1
            IF ss1 + ss2 > FieldArea THEN ss2 = FieldArea - ss1
        ELSE
            ss1 = s1
            ss2 = s2 - s1
            IF ss1 < InputViewStart THEN ss1 = 0: ss2 = s2 - InputViewStart + 1
            IF ss1 > InputViewStart THEN ss1 = ss1 - InputViewStart + 1: ss2 = s2 - s1
        END IF
        Selection.Value$ = MID$(NewValue, s1 + 1, s2 - s1)

        LINE (InputField.X + ss1 * CharW, DialogY + 5 + _FONTHEIGHT * (3 + totalLines))-STEP(ss2 * CharW, _FONTHEIGHT), _RGBA32(255, 255, 255, 150), BF
    END IF
    RETURN

    CheckButtons:
    'Hover highlight:
    WHILE _MOUSEINPUT: WEND
    mb = _MOUSEBUTTON(1): mx = _MOUSEX: my = _MOUSEY
    FOR cb = 1 TO TotalButtons
        IF (mx >= Buttons(cb).X) AND (mx <= Buttons(cb).X + Buttons(cb).W) THEN
            IF (my >= Buttons(cb).Y) AND (my < Buttons(cb).Y + _FONTHEIGHT) THEN
                LINE (Buttons(cb).X, Buttons(cb).Y)-STEP(Buttons(cb).W, _FONTHEIGHT - 1), _RGBA32(230, 230, 230, 235), BF
            END IF
        END IF
    NEXT cb

    IF mb THEN
        IF mx >= InputField.X AND my >= DialogY + 3 + _FONTHEIGHT * (3 + totalLines) AND mx <= InputField.X + (FieldArea * CharW - 10) AND my <= DialogY + 3 + _FONTHEIGHT * (3 + totalLines) + _FONTHEIGHT + 4 THEN
            'Clicking inside the text field positions the cursor
            WHILE _MOUSEBUTTON(1)
                _LIMIT 500
                mb = _MOUSEINPUT
            WEND
            Cursor = ((mx - InputField.X) / CharW) + (InputViewStart - 1)
            IF Cursor > LEN(NewValue) THEN Cursor = LEN(NewValue)
            Selected = 0
            RETURN
        END IF

        FOR cb = 1 TO TotalButtons
            IF (mx >= Buttons(cb).X) AND (mx <= Buttons(cb).X + Buttons(cb).W) THEN
                IF (my >= Buttons(cb).Y) AND (my < Buttons(cb).Y + _FONTHEIGHT) THEN
                    DefaultButton = cb
                    WHILE _MOUSEBUTTON(1): _LIMIT 500: mb = _MOUSEINPUT: WEND
                    mb = 0: nmx = _MOUSEX: nmy = _MOUSEY
                    IF nmx = mx AND nmy = my THEN DIALOGRESULT = cb
                    RETURN
                END IF
            END IF
        NEXT cb
    END IF
    RETURN
END FUNCTION


'method adapted form http://stackoverflow.com/questions/4106363/converting-rgb-to-hsb-colors
FUNCTION hsb~& (__H AS _FLOAT, __S AS _FLOAT, __B AS _FLOAT, A AS _FLOAT)
    DIM H AS _FLOAT, S AS _FLOAT, B AS _FLOAT

    H = map(__H, 0, 255, 0, 360)
    S = map(__S, 0, 255, 0, 1)
    B = map(__B, 0, 255, 0, 1)

    IF S = 0 THEN
        hsb~& = _RGBA32(B * 255, B * 255, B * 255, A)
        EXIT FUNCTION
    END IF

    DIM fmx AS _FLOAT, fmn AS _FLOAT
    DIM fmd AS _FLOAT, iSextant AS INTEGER
    DIM imx AS INTEGER, imd AS INTEGER, imn AS INTEGER

    IF B > .5 THEN
        fmx = B - (B * S) + S
        fmn = B + (B * S) - S
    ELSE
        fmx = B + (B * S)
        fmn = B - (B * S)
    END IF

    iSextant = INT(H / 60)

    IF H >= 300 THEN
        H = H - 360
    END IF

    H = H / 60
    H = H - (2 * INT(((iSextant + 1) MOD 6) / 2))

    IF iSextant MOD 2 = 0 THEN
        fmd = (H * (fmx - fmn)) + fmn
    ELSE
        fmd = fmn - (H * (fmx - fmn))
    END IF

    imx = _ROUND(fmx * 255)
    imd = _ROUND(fmd * 255)
    imn = _ROUND(fmn * 255)

    SELECT CASE INT(iSextant)
        CASE 1
            hsb~& = _RGBA32(imd, imx, imn, A)
        CASE 2
            hsb~& = _RGBA32(imn, imx, imd, A)
        CASE 3
            hsb~& = _RGBA32(imn, imd, imx, A)
        CASE 4
            hsb~& = _RGBA32(imd, imn, imx, A)
        CASE 5
            hsb~& = _RGBA32(imx, imn, imd, A)
        CASE ELSE
            hsb~& = _RGBA32(imx, imd, imn, A)
    END SELECT

END FUNCTION


FUNCTION map! (value!, minRange!, maxRange!, newMinRange!, newMaxRange!)
    map! = ((value! - minRange!) / (maxRange! - minRange!)) * (newMaxRange! - newMinRange!) + newMinRange!
END FUNCTION


'$INCLUDE:'sxript.bm'
