# Copyright (c) 2011 CSIRO
# Australia Telescope National Facility (ATNF)
# Commonwealth Scientific and Industrial Research Organisation (CSIRO)
# PO Box 76, Epping NSW 1710, Australia
# atnf-enquiries@csiro.au
#
# The ASKAP software distribution is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the License,
# or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
#
# To build normally:
# $ make
#

CUB_HOME = /home/lbarnes/main/SKA/askap-benchmarks/cub/
CXX = g++
CFLAGS = -Wall -Wextra -O3 -fstrict-aliasing -fPIC
INCLUDE = -I$(CUDA_INSTALL)/include -I$(CUB_HOME)/cub

NVCC = nvcc
NVCCFLAGS = -lineinfo -arch=sm_35 -O3 --compiler-options -fPIC

ifeq ($(CUDA),1)
	CFLAGS += -D__CUDA__
	NVCCFLAGS += -D__CUDA__
endif
EXENAME = tMultiScaleCleanCuda
OBJS = $(EXENAME).o Stopwatch.o MultiScaleGolden.o MultiScaleCuda.o

all:		$(EXENAME)

HogbomCuda.o:	HogbomCuda.cu HogbomCuda.h Parameters.h
		$(NVCC) $(NVCCFLAGS) $(INCLUDE) -c $<

MultiScaleCuda.o:	MultiScaleCuda.cu MultiScaleCuda.h Parameters.h
		$(NVCC) $(NVCCFLAGS) $(INCLUDE) -c $<

%.o:		%.cc Parameters.h %.h 
		$(CXX) $(CFLAGS) $(INCLUDE) -c $<

#Have to repeat this since there's no tMultiScaleCleanCuda.h
%.o:		%.cc Parameters.h 
		$(CXX) $(CFLAGS) $(INCLUDE) -c $<

$(EXENAME):	$(OBJS)
		$(NVCC) $(NVCCFLAGS) -o $(EXENAME) $(OBJS)

clean:
		rm -f $(EXENAME) *.o

