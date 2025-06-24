import 'package:flutter/material.dart';

class QuizDetailsHeader extends StatefulWidget {
  final Map<String, dynamic> quizData;
  final Function(Map<String, dynamic>) onUpdate;
  final VoidCallback onToggleStatus;

  const QuizDetailsHeader({
    super.key,
    required this.quizData,
    required this.onUpdate,
    required this.onToggleStatus,
  });

  @override
  State<QuizDetailsHeader> createState() => _QuizDetailsHeaderState();
}

class _QuizDetailsHeaderState extends State<QuizDetailsHeader> {
  bool _isEditing = false;
  bool _isUpdating = false;

  // Controllers for editing quiz details
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _codeController;
  late Map<String, dynamic> _editingData;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(QuizDetailsHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.quizData != oldWidget.quizData) {
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    _titleController = TextEditingController(
      text: widget.quizData['title'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.quizData['description'] ?? '',
    );
    _codeController = TextEditingController(
      text: widget.quizData['code'] ?? '',
    );

    // Create a copy of the quizData for editing
    _editingData = Map<String, dynamic>.from(widget.quizData);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _updateQuizDetails() async {
    setState(() => _isUpdating = true);

    _editingData['title'] = _titleController.text;
    _editingData['description'] = _descriptionController.text;
    _editingData['code'] = _codeController.text;

    await widget.onUpdate(_editingData);

    setState(() {
      _isUpdating = false;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Informasi Ujian',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (!_isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit Ujian',
                    onPressed: () => setState(() => _isEditing = true),
                  )
                else
                  IconButton(
                    icon: _isUpdating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    tooltip: 'Simpan Perubahan',
                    onPressed: _isUpdating ? null : _updateQuizDetails,
                  ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _isEditing ? _buildEditForm() : _buildDisplayInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Judul Ujian',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Deskripsi',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _codeController,
          decoration: const InputDecoration(
            labelText: 'Kode Ujian',
            border: OutlineInputBorder(),
            helperText: 'Biarkan kosong untuk menghasilkan secara otomatis',
          ),
          maxLength: 8,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Switch(
              value: _editingData['is_active'] ?? false,
              onChanged: (value) {
                setState(() {
                  _editingData['is_active'] = value;
                });
              },
            ),
            const Text('Aktif'),
            const SizedBox(width: 16),
            const Text('Batas Waktu:'),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: '${_editingData['time_limit'] ?? 0}',
                decoration: const InputDecoration(
                  labelText: 'Menit',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _editingData['time_limit'] = int.tryParse(value) ?? 0;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDisplayInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quiz: ${widget.quizData['title']}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (widget.quizData['description'] != null &&
            widget.quizData['description'].toString().isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('${widget.quizData['description']}'),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Code: ${widget.quizData['code']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: Icon(
                widget.quizData['is_active'] == true
                    ? Icons.toggle_on
                    : Icons.toggle_off,
                color: widget.quizData['is_active'] == true
                    ? Colors.green
                    : Colors.grey,
              ),
              label: Text(
                widget.quizData['is_active'] == true ? 'Aktif' : 'Tidak Aktif',
                style: TextStyle(
                  color: widget.quizData['is_active'] == true
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
              onPressed: widget.onToggleStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
            ),
          ],
        ),
        if (widget.quizData['time_limit'] != null &&
            widget.quizData['time_limit'] > 0) ...[
          const SizedBox(height: 8),
          Text(
            'Batas Waktu: ${widget.quizData['time_limit']} menit',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ],
    );
  }
}
