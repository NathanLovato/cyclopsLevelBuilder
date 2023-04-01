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

#Public data to set before activating command
var blocks_root_path:NodePath
var block_path:NodePath
var move_dir_normal:Vector3
var move_amount:float
var face_id:int
var lock_uvs:bool = false


#Private
var block_name:String
var block_selected:bool
var tracked_block_data:ConvexBlockData

var deleted:bool = false


func _init():
	command_name = "Move face"

func move_to(offset:Vector3, intermediate:bool):
#	print("move_to off %s faceid %s amount %s movedir %s" % [offset, face_id, move_amount, move_dir_normal])
	
	var ctl_mesh:ConvexVolume = ConvexVolume.new()
	ctl_mesh.init_from_convex_block_data(tracked_block_data)
	ctl_mesh.translate_face(face_id, offset, lock_uvs)

	var block:CyclopsConvexBlock = builder.get_node(block_path)
	
	if ctl_mesh.is_empty():
		if !intermediate:
			block.queue_free()
			deleted = true
		return
	
	ctl_mesh.remove_unused_planes()
	
	var result_data:ConvexBlockData = ctl_mesh.to_convex_block_data()
	block.block_data = result_data

	
func do_it_intermediate():
	if !tracked_block_data:
		var block:CyclopsConvexBlock = builder.get_node(block_path)
		
		block_name = block.name
		block_selected = block.selected
		tracked_block_data = block.block_data

	move_to(move_dir_normal * move_amount, true)

func do_it():
	
	if !tracked_block_data:
		var block:CyclopsConvexBlock = builder.get_node(block_path)
		
		block_name = block.name
		block_selected = block.selected
		tracked_block_data = block.block_data
	
	move_to(move_dir_normal * move_amount, false)

func undo_it():
	if deleted:
		var block:CyclopsConvexBlock = preload("../controls/cyclops_convex_block.gd").new()
		
		var blocks_root:CyclopsBlocks = builder.get_node(blocks_root_path)
		blocks_root.add_child(block)
		block.owner = builder.get_editor_interface().get_edited_scene_root()
		block.block_data = tracked_block_data
		block.name = block_name
		block.selected = block_selected
		
		deleted = false
		return
	
	move_to(Vector3.ZERO, false)

