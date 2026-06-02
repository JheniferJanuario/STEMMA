public class AddMedicalRecordRequest
{
    public Guid ConsultationId { get; set; }
    public string Description { get; set; } = string.Empty;
    public string Diagnostico { get; set; } = string.Empty;
}