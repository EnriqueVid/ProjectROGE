#rgbasm -o obj/main.o src/main.s
#rgblink -m game.map -n game.sym -o game.gb game.obj
#rgbfix -v -p 0 hello-world.gb

# NOMBRE DEL FICHERO DE SALIDA
APP    := game
COMP   := rgbasm	# COMPILADOR
LNK    := rgblink	# LINKER
FIX    := rgbfix	# FIXER
CFLAGS := 			# FLAGS DEL COMPILADOR
LFLAGS := 			# FLAGS DEL LINKER
FFLAGS := 			# FLAGS DEL FIXER
MKDIR  := mkdir -p
SRC    := src
OBJ    := obj

#RUTA DEL EMULADOR DE GAME BOY
EMUROUTE := ../../Universidad/GB\ Emulator/BGB/bgb64.exe


ALLASMS		:= $(shell find $(SRC) -type f -iname *.s -not -iname *.h.s)	# LISTA DE TODOS LOS FICHEROS ASM
ALLOBJS		:= $(patsubst %.s,%.o,$(ALLASMS))								# LISTA DE TODOS LOS FICHEROS OBJ
SUBDIRS 	:= $(shell find $(SRC) -type d)									# LISTA DE TODAS LAS CARPETAS DE SRC
OBJSUBDIRS 	:= $(patsubst $(SRC)%,$(OBJ)%,$(SUBDIRS))						# LISTA DE TODAS LAS CARPETAS DE OBJ

.PHONY: dir
.PHONY: run
.PHONY: clean

# COMPILACION DEL PROGRAMA
$(APP) : $(OBJSUBDIRS) $(ALLOBJS)
	$(LNK) -m$(OBJ)/$(APP).map -n$(OBJ)/$(APP).sym -o $(APP).gbc $(patsubst $(SRC)%,$(OBJ)%,$(ALLOBJS))
	$(FIX) -v -p 0 $(APP).gbc
	$(LNK) -o $(APP).gb $(patsubst $(SRC)%,$(OBJ)%,$(ALLOBJS))
	$(FIX) -v -p 0 $(APP).gb


# CREAR LA CARPETA OBJ SI NO EXISTE
$(OBJSUBDIRS) :
	$(MKDIR) $(OBJSUBDIRS)


%.o : %.s
	$(COMP) -o $(patsubst $(SRC)%,$(OBJ)%,$@) $^ $(CFLAGS)

# OTROS

run : $(APP)
	wine $(EMUROUTE) $(APP).gb

dir:
	$(info $(SUBDIRS))
	$(info $(OBJSUBDIRS))
	$(info $(ALLASMS))
	$(info $(ALLOBJS))

clean: 
	rm -rf $(OBJ) *.gb *.gbc
