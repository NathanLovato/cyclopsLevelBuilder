# MIT License
#
# Copyright (c) 2023 Mark McKay
# https://github.com/blackears/cyclopsLevelBuilder
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

@tool
class_name CommandMoveFace
extends CyclopsCommand

var move_dir_normal:Vector3
var move_amount:float

var tracked_block:CyclopsBlock
var tracked_block_data:ConvexBlockData
var face_id:int
var lock_uvs:bool = false


func _init():
	command_name = "Move face"

func move_to(offset:Vector3):
#	print("move_to off %s faceid %s amount %s movedir %s" % [offset, face_id, move_amount, move_dir_normal])
	
	var ctl_mesh:ConvexVolume = ConvexVolume.new()
	ctl_mesh.init_from_convex_block_data(tracked_block_data)
	ctl_mesh.translate_face(face_id, offset, lock_uvs)
	var result_data:ConvexBlockData = ctl_mesh.to_convex_block_data()
	tracked_block.block_data = result_data


func do_it():
	move_to(move_dir_normal * move_amount)

func undo_it():
	move_to(Vector3.ZERO)

