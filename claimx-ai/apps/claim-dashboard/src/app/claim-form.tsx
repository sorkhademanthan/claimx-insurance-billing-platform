import React, { useState, useEffect } from 'react';
import api from '../utils/api';

interface Policy {
  id: string;
  policyNumber: string;
  type: string;
}

// Add props interface
interface ClaimFormProps {
  onSuccess?: () => void;
}

export const ClaimForm: React.FC<ClaimFormProps> = ({ onSuccess }) => {
  const [policies, setPolicies] = useState<Policy[]>([]);
  const [formData, setFormData] = useState({
    policyId: '',
    incidentDate: '',
    incidentType: 'ACCIDENT',
    description: '',
  });
  const [file, setFile] = useState<File | null>(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    // In a real app, fetch this from API. For now, hardcoded to match seed.
    setPolicies([
      { id: '7f54e808-4761-4c0b-8999-4727142ffe5c', policyNumber: 'POL-12345678', type: 'AUTO' }
    ]);
    setFormData(prev => ({ ...prev, policyId: '7f54e808-4761-4c0b-8999-4727142ffe5c' }));
  }, []);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setFile(e.target.files[0]);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const payload = {
        ...formData,
        incidentDate: new Date(formData.incidentDate).toISOString(),
      };

      const { data: claim } = await api.post('/claims', payload);

      if (file && claim.id) {
        const uploadData = new FormData();
        uploadData.append('file', file);
        await api.post(`/claims/${claim.id}/upload`, uploadData, {
          headers: { 'Content-Type': 'multipart/form-data' },
        });
      }

      alert('✅ Claim filed successfully!');
      setFormData(prev => ({ ...prev, description: '' }));
      setFile(null);
      
      // Trigger refresh in parent
      if (onSuccess) {
        onSuccess();
      }

    } catch (error: any) {
      console.error('Error filing claim:', error);
      alert(`❌ Failed to file claim: ${error.response?.data?.message || error.message}`);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-2xl mx-auto bg-white p-8 rounded-lg shadow-lg mt-10">
      <h2 className="text-2xl font-bold text-gray-800 mb-6">File a New Claim</h2>
      <form onSubmit={handleSubmit} className="space-y-6">
        <div>
          <label className="block text-sm font-medium text-gray-700">Select Policy</label>
          <select name="policyId" value={formData.policyId} onChange={handleChange} className="w-full border border-gray-300 rounded px-3 py-2">
            {policies.map((p) => <option key={p.id} value={p.id}>{p.policyNumber}</option>)}
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700">Date</label>
          <input type="datetime-local" name="incidentDate" value={formData.incidentDate} onChange={handleChange} className="w-full border border-gray-300 rounded px-3 py-2" required />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700">Type</label>
          <select name="incidentType" value={formData.incidentType} onChange={handleChange} className="w-full border border-gray-300 rounded px-3 py-2">
            <option value="ACCIDENT">Accident</option>
            <option value="THEFT">Theft</option>
            <option value="NATURAL_DISASTER">Natural Disaster</option>
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700">Description</label>
          <textarea name="description" rows={4} value={formData.description} onChange={handleChange} className="w-full border border-gray-300 rounded px-3 py-2" required />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700">Evidence</label>
          <input type="file" onChange={handleFileChange} className="w-full" accept="image/*" />
        </div>
        <button type="submit" disabled={loading} className="w-full bg-blue-600 text-white py-3 rounded hover:bg-blue-700">
          {loading ? 'Submitting...' : 'Submit Claim'}
        </button>
      </form>
    </div>
  );
};
