namespace STEMMA.Domain.Consultas.Entities;

public class Prontuario
{
    public Guid Id { get; private set; }

    public Guid ConsultaId { get; private set; }

    public string Observacoes { get; private set; }

    public string Diagnostico { get; private set; }

    public DateTime DataRegistro { get; private set; }

    protected Prontuario() { }

    public Prontuario(
        Guid consultaId,
        string observacoes,
        string diagnostico)
    {
        Validar(observacoes, diagnostico);

        Id = Guid.NewGuid();
        ConsultaId = consultaId;
        Observacoes = observacoes;
        Diagnostico = diagnostico;
        DataRegistro = DateTime.UtcNow;
    }

    public void AtualizarObservacoes(string observacoes)
    {
        if (string.IsNullOrWhiteSpace(observacoes))
            throw new Exception("Observações obrigatórias.");

        Observacoes = observacoes;
    }

    private void Validar(
        string observacoes,
        string diagnostico)
    {
        if (string.IsNullOrWhiteSpace(observacoes))
            throw new Exception("Observações obrigatórias.");

        if (string.IsNullOrWhiteSpace(diagnostico))
            throw new Exception("Diagnóstico obrigatório.");
    }
}