from flask import flask, Blueprint, request, jsonify
from service.crisis_report_generator import CrisisEventService  # Importing the service layer

# Initialize Blueprint for the CrisisEvent controller
crisis_event_bp = Blueprint('crisis_event_bp', __name__)

# Instance of CrisisEventService to handle business logic
crisis_event_service = CrisisEventService()

# GET request to fetch all crisis events
@crisis_event_bp.route('/api/crisis-events', methods=['GET'])
def get_crisis_events():
    crisis_events = crisis_event_service.get_all_events()
    return jsonify(crisis_events), 200

# GET request to fetch a specific crisis event by ID
@crisis_event_bp.route('/api/crisis-events/<int:event_id>', methods=['GET'])
def get_crisis_event(event_id):
    crisis_event = crisis_event_service.get_event_by_id(event_id)
    if crisis_event:
        return jsonify(crisis_event), 200
    return jsonify({"error": "Crisis event not found"}), 404

# POST request to create a new crisis event
@crisis_event_bp.route('/api/crisis-events', methods=['POST'])
def create_crisis_event():
    data = request.json
    try:
        new_event = crisis_event_service.create_event(data)
        return jsonify(new_event), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

# PUT request to update an existing crisis event by ID
@crisis_event_bp.route('/api/crisis-events/<int:event_id>', methods=['PUT'])
def update_crisis_event(event_id):
    data = request.json
    updated_event = crisis_event_service.update_event(event_id, data)
    if updated_event:
        return jsonify(updated_event), 200
    return jsonify({"error": "Crisis event not found or could not be updated"}), 404

# DELETE request to delete a crisis event by ID
@crisis_event_bp.route('/api/crisis-events/<int:event_id>', methods=['DELETE'])
def delete_crisis_event(event_id):
    if crisis_event_service.delete_event(event_id):
        return jsonify({"message": "Crisis event deleted successfully"}), 200
    return jsonify({"error": "Crisis event not found or could not be deleted"}), 404
